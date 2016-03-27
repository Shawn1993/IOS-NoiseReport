//
//  NCPAppDelegate.h
//  NoiseComplain
//
//  Created by mura on 11/27/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMapManager;

@interface NCPAppDelegate : UIResponder <UIApplicationDelegate>

// UIWindow对象
@property(strong, nonatomic) UIWindow *window;

// 百度地图主引擎对象
@property(strong, nonatomic) BMKMapManager *mapManager;

@end
