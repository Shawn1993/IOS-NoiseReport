//
//  NCPSettingViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPSettingViewController.h"

@interface NCPSettingViewController ()

/** 导航栏按钮Done点击事件 */
- (IBAction)barButtonDoneClick:(id)sender;
/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender;

@end

@implementation NCPSettingViewController

/** 导航栏按钮Done点击事件 */
- (IBAction)barButtonDoneClick:(id)sender {
    // 退出选项视图
    [self dismissViewControllerAnimated:YES completion:^{
        // 保存噪声仪的选项
    }];
}

/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender {
    // 退出选项视图, 不执行任何操作
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
