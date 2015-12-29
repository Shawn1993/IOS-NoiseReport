//
//  NCPAppDelegate.h
//  NoiseComplain
//
//  Created by mura on 11/27/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface NCPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BMKMapManager *mapManager;

@end
