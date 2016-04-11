//
//  NCPProgressViewController.h
//  NoiseComplain
//
//  Created by mura on 4/8/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCPComplainForm;

/*
 * 投诉进度视图控制器
 */
@interface NCPProgressViewController : UITableViewController

// 投诉表单对象
@property(nonatomic, weak) NCPComplainForm *form;

@end
