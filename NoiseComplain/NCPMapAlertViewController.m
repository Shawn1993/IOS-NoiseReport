//
//  NCPMapAlertViewController.m
//  NoiseComplain
//
//  Created by shawn on 17/3/2016.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPMapAlertViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface NCPMapAlertViewController ()

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation NCPMapAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self findCollectionView:self.view];

    self.mapView  = [[BMKMapView alloc] init];
    [self.view addSubview:self.mapView];
}
- (void)viewDidLayoutSubviews{
    NSLog(@"test",nil);
    [super viewDidLayoutSubviews];
    self.mapView.frame = CGRectMake(20, self.collectionView.frame.size.height, self.view.bounds.size.width-40, self.view.bounds.size.height-2*self.collectionView.frame.size.height);
  
}

-(void)findCollectionView:(UIView*) view{
    if(view.subviews.count == 0)
        return;
    for (UIView *v in view.subviews) {
        if([v isKindOfClass:[UICollectionView class]]){
            self.collectionView = (UICollectionView*)v;
        }else{
            [self findCollectionView:v];
        }
    }
}


@end
