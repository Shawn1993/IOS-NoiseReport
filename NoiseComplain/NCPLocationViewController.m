//
//  NCPLocationViewController.m
//  NoiseComplain
//
//  Created by mura on 11/29/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPLocationViewController.h"
#import "NCPComplainForm.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


#pragma mark - private interface
@interface NCPLocationViewController() <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (weak, nonatomic) IBOutlet UIButton *updateLocationButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImageView *locationView;

@property (nonatomic) BMKMapView *mapView;

@property (nonatomic) BMKLocationService *locationService;

@property (nonatomic) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, getter=isPinUseUserLocation) BOOL pinUseUserLocation;

@property (nonatomic, getter=isMapRegionChange) BOOL mapRegionChange;

@property (nonatomic) CLLocationCoordinate2D pinCoordinate;

@property (nonatomic) CLLocationCoordinate2D locationCoordinate;

@property (nonatomic) NSString *pinAddress;

@end


#pragma mark - implementation
@implementation NCPLocationViewController

-(void)viewDidLoad
{
    
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    [self.mapViewContainer addSubview:self.mapView];
    
    self.locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
    [self.mapViewContainer addSubview:self.locationView];
    
    self.locationService = [[BMKLocationService alloc] init];
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    [self initData];
}

-(void)initData
{

    CLLocationDegrees latitude = [[[NCPComplainForm current] latitude] doubleValue];
    CLLocationDegrees longtitude = [[[NCPComplainForm current] longitude] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longtitude);
    self.pinUseUserLocation = (latitude==0&&longtitude==0);
    self.mapRegionChange = NO;
    self.pinAddress = [[NCPComplainForm current] address];
    
    if(!self.isPinUseUserLocation)
    {
        [self.mapView setCenterCoordinate:coordinate animated:YES];
        [self setPinCoordinate:coordinate];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    self.geoCodeSearch.delegate = self;
    [self.locationService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearch.delegate = nil;
    [self.locationService stopUserLocationService];
}

-(void)viewDidLayoutSubviews
{
    self.mapView.frame = self.mapViewContainer.bounds;
    
    self.locationView.layer.anchorPoint=CGPointMake(0.5, 1.0);
    self.locationView.center = self.mapView.center;
}

# pragma mark - setter and getter

-(void)setPinCoordinate:(CLLocationCoordinate2D)pinCoordinate
{
    _pinCoordinate = pinCoordinate;
    [self checkUpdateButtonIsNeedHide];
}

-(void)setLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate
{
    _locationCoordinate = locationCoordinate;
    [self checkUpdateButtonIsNeedHide];
}

-(void)checkUpdateButtonIsNeedHide
{
    BMKMapPoint locationPoint = BMKMapPointForCoordinate(self.locationCoordinate);
    BMKMapPoint pinPoint = BMKMapPointForCoordinate(self.pinCoordinate);
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pinPoint,locationPoint);
    self.updateLocationButton.hidden = (fabs(distance)<1);
}

# pragma mark - 按钮响应
- (IBAction)doneButtonClick:(id)sender
{
    [NCPComplainForm current].latitude =[NSNumber numberWithDouble:[self pinCoordinate].latitude];
    [NCPComplainForm current].longitude =[NSNumber numberWithDouble:[self pinCoordinate].longitude];
//    [NCPComplainForm current].address = (self.pinAddress&&self.pinAddress.length)?(self.pinAddress):(@"选点失败");
    if((self.pinAddress && self.pinAddress.length )|| (!self.isMapRegionChange)){
        [NCPComplainForm current].address =self.pinAddress;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]                             initWithTitle:@"当前位置不可用"
                                                                                        message:@"请重新选择"
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"确定"
                                                                              otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (IBAction)updateLocationButtonClick:(id)sender
{
    if(self.locationCoordinate.latitude&&self.locationCoordinate.longitude)
    {
        self.pinCoordinate = self.locationCoordinate;
        [self.mapView setCenterCoordinate:[self pinCoordinate] animated:YES];
    }
}
    

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.pinAddress = nil;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    [self setPinCoordinate:coordinate];
  
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = self.pinCoordinate;
    [self.geoCodeSearch reverseGeoCode:option];
    
    self.mapRegionChange =YES;
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(!userLocation)
        return;
    
    [self.mapView updateLocationData: userLocation];
    self.locationCoordinate =  userLocation.location.coordinate;
    
    if(self.isPinUseUserLocation){
        self.pinUseUserLocation = NO;
        self.pinCoordinate = self.locationCoordinate;
        [self.mapView setCenterCoordinate:self.pinCoordinate animated:YES];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位错误");
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.pinAddress = result.address;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
 
}

@end
