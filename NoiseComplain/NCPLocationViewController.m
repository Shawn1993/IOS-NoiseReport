//
//  NCPLocationViewController.m
//  NoiseComplain
//
//  Created by mura on 11/29/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#pragma mark - private interface
@interface NCPLocationViewController() <BMKMapViewDelegate,BMKLocationServiceDelegate>{
    
    
}

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) BMKLocationService *locationService;

- (IBAction)doneButtonClick:(id)sender;

@end


#pragma mark - implementation
@implementation NCPLocationViewController

-(void)viewDidLoad{
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.showsUserLocation = YES ;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.mapViewContainer addSubview:self.mapView];
    
    self.locationService = [[BMKLocationService alloc] init];
    [self.locationService startUserLocationService];
}

-(void)viewWillAppear:(BOOL)animated{
    self.mapView.delegate = self;
    self.locationService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
}

-(void)viewDidLayoutSubviews{
    self.mapView.frame = self.mapViewContainer.bounds;
}


- (IBAction)doneButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma  mark - BMKLocationServiceDelegate

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    
}

@end
