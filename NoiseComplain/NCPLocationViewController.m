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
@interface NCPLocationViewController() <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (weak, nonatomic) IBOutlet UIButton *updateLocationButton;

@property (nonatomic) UIImageView *locationView;

@property (nonatomic) BMKMapView *mapView;

@property (nonatomic) BMKLocationService *locationService;

@property (nonatomic) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, getter=isUseUserLocation) BOOL useUserLocation;

@property (nonatomic) CLLocationCoordinate2D pinCoordinate;

@property (nonatomic) CLLocationCoordinate2D locationCoordinate;

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
    [self.locationService startUserLocationService];
    
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    [self initData];
}

-(void)initData
{
    CLLocationDegrees latitude = [[[NCPComplainForm current] latitude] doubleValue];
    CLLocationDegrees longtitude = [[[NCPComplainForm current] longitude] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longtitude);
    self.useUserLocation = (latitude==0&&longtitude==0);
    
    if(!self.isUseUserLocation)
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearch.delegate = nil;
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
//    NSLog(@"%f,%f",[self pinCoordinate].latitude ,[self pinCoordinate].longitude);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateLocationButtonClick:(id)sender
{
    [self setPinCoordinate:[self locationCoordinate]];
    [self.mapView setCenterCoordinate:[self pinCoordinate] animated:YES];
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    [self setPinCoordinate:coordinate];
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(!userLocation)
        return;
    [self.mapView updateLocationData: userLocation];
    self.locationCoordinate =  userLocation.location.coordinate;
    
    if(self.isUseUserLocation){
        self.useUserLocation = NO;
        self.pinCoordinate = self.locationCoordinate;
        [self.mapView setCenterCoordinate:self.pinCoordinate animated:YES];
    }
}

@end
