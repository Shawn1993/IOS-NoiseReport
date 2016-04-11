//
//  NCPComplainDetailViewController.h
//  NoiseComplain
//
//  Created by mura on 3/27/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCPComplainForm;

/**
 * 噪声投诉详情ViewController
 */
@interface NCPDetailViewController : UITableViewController

// 投诉表单对象
@property(nonatomic, weak) NCPComplainForm *form;

@end
