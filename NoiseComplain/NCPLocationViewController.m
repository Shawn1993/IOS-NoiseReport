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
@interface NCPLocationViewController() <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    
    CLLocationCoordinate2D mPinCoordinate;
    CLLocationCoordinate2D mLocationCoordinate;
}

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (weak, nonatomic) IBOutlet UIButton *updateLocationButton;

@property (strong, nonatomic) UIImageView *locationView;

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) BMKLocationService *locationService;

@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;

@end


#pragma mark - implementation
@implementation NCPLocationViewController

-(void)viewDidLoad{
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    [self.mapViewContainer addSubview:self.mapView];
    
    self.locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
    [self.mapViewContainer addSubview:self.locationView];
    
    self.locationService = [[BMKLocationService alloc] init];
    [self.locationService startUserLocationService];
    
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    self.geoCodeSearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearch.delegate = nil;
}

-(void)viewDidLayoutSubviews{
    self.mapView.frame = self.mapViewContainer.bounds;
    
    self.locationView.layer.anchorPoint=CGPointMake(0.5, 1.0);
    self.locationView.center = self.mapView.center;
}

# pragma mark - 按钮响应
- (IBAction)doneButtonClick:(id)sender {
    [NCPComplainForm current].latitude =[NSNumber numberWithDouble: mPinCoordinate.latitude];
    [NCPComplainForm current].longitude =[NSNumber numberWithDouble: mPinCoordinate.longitude];
    [NCPComplainForm current].address =
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateLocationButtonClick:(id)sender {
    mPinCoordinate = mLocationCoordinate;
    [self.mapView setCenterCoordinate:mPinCoordinate animated:YES];
    [self checkUpdateButtonIsNeedHide];
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    mPinCoordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    [self checkUpdateButtonIsNeedHide];
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if(!userLocation)
        return;
    
    [self.mapView updateLocationData:userLocation];
    
    mLocationCoordinate = userLocation.location.coordinate;
    
    [self checkUpdateButtonIsNeedHide];
}

#pragma mark -


#pragma mark - wrapper

-(void)checkUpdateButtonIsNeedHide{
    BMKMapPoint locationPoint = BMKMapPointForCoordinate(mLocationCoordinate);
    BMKMapPoint pinPoint = BMKMapPointForCoordinate(mPinCoordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pinPoint, locationPoint);
    
    self.updateLocationButton.hidden = (fabs(distance)<1);
}

@end
