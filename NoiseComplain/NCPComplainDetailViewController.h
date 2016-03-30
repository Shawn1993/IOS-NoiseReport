//
//  NCPComplainDetailViewController.h
//  NoiseComplain
//
//  Created by mura on 3/27/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 噪声投诉详情与受理进度ViewController
 */

@class NCPComplainForm;

@interface NCPComplainDetailViewController : UITableViewController

// 投诉表单对象
@property(nonatomic, weak) NCPComplainForm *form;

@end
