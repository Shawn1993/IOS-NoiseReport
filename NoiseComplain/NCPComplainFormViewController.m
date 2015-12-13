//
//  NCPComplainFormViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainFormViewController.h"
#import "NCPWebRequest.h"

@interface NCPComplainFormViewController () <UITableViewDelegate>

/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender;
/** 导航栏按钮Clear点击事件 */
- (IBAction)barButtonClearClick:(id)sender;

@end

@implementation NCPComplainFormViewController

#pragma mark - 生命周期事件

- (void)viewDidLoad {
    
}

#pragma mark - UITableView数据源协议与代理协议

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            // 测量结果session
            break;
        case 1:
            // 噪声源位置session
            break;
        case 2:
            // 噪声源信息session
            break;
        case 3:
            // 提交投诉session
            [NCPWebRequest connectWithPage:@"test" completionHandler:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 控件事件

/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 导航栏按钮Clear点击事件 */
- (IBAction)barButtonClearClick:(id)sender {

}

@end
