//
//  NCPLocationViewController.h
//  NoiseComplain
//
//  Created by mura on 11/29/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 地图选点定位视图控制器
 */

@class NCPComplainForm;

@interface NCPLocationViewController : UIViewController

// 投诉表单对象
@property(nonatomic, weak) NCPComplainForm *form;

@end
