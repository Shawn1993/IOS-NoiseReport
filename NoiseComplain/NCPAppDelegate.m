//
//  NCPAppDelegate.m
//  NoiseComplain
//
//  Created by mura on 11/27/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPAppDelegate.h"

#import "BaiduMapAPI_Base/BMKMapManager.h"

@interface NCPAppDelegate ()

@end

@implementation NCPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.mapManager = [[BMKMapManager alloc] init];

    BOOL result = [self.mapManager start:@"cIvjsxRwYmIGgi1Gwob3V6i4" generalDelegate:nil];
    if (!result) {
        NSLog(@"manager start failed!");
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
