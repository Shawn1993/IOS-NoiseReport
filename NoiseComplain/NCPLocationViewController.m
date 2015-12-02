//
//  NCPLocationViewController.m
//  NoiseComplain
//
//  Created by mura on 11/29/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPLocationViewController.h"

@interface NCPLocationViewController ()


/** 导航栏按钮Done点击事件 */
- (IBAction)barButtonDoneClick:(id)sender;
/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender;

@end

@implementation NCPLocationViewController

/** 导航栏按钮Done点击事件 */
- (IBAction)barButtonDoneClick:(id)sender {
    // 退出定位视图
    [self dismissViewControllerAnimated:YES completion:^{
        // 保存定位结果
    }];
}

/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender {
    // 退出定位视图, 不做任何操作
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
