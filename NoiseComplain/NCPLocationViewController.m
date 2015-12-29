//
//  NCPLocationViewController.m
//  NoiseComplain
//
//  Created by mura on 11/29/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#pragma mark - private interface
@interface NCPLocationViewController (){
    
    
}

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (strong, nonatomic) BMKMapView *mapView;

- (IBAction)doneButtonClick:(id)sender;

@end


#pragma mark - implementation
@implementation NCPLocationViewController

-(void)viewDidLoad{
    self.mapView = [[BMKMapView alloc] init];
    [self.mapViewContainer addSubview:self.mapView];
}

-(void)viewDidLayoutSubviews{
    self.mapView.frame = self.mapViewContainer.bounds;
}


- (IBAction)doneButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
