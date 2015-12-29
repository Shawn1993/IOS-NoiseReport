//
//  NCPComplainFormViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainFormViewController.h"
#import "NCPWebRequest.h"
#import "NCPComplainForm.h"
#import "NCPComplainFormDAO.h"

@interface NCPComplainFormViewController () <UITableViewDelegate>

/*!
 *  导航栏按钮Cancel点击事件
 *
 *  @param sender sender
 */
- (IBAction)barButtonCancelClick:(id)sender;

/*!
 *  导航栏按钮Clear点击事件
 *
 *  @param sender sender
 */
- (IBAction)barButtonClearClick:(id)sender;

@end

@implementation NCPComplainFormViewController

#pragma mark - 生命周期事件

/*!
 *  视图初始化
 */
- (void)viewDidLoad {
    
}

#pragma mark - UITableView数据源协议与代理协议

/*!
 *  表格选择代理方法
 *
 *  @param tableView 表格视图
 *  @param indexPath 表格索引路径
 */
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
        {
            // 创建投诉表单对象
            NCPComplainForm *form = [self generateComplainForm];
            
            // 将投诉表单发送至服务器
            [self sendComplainForm:form];
            
            // 将投诉表单保存至本地
            [self saveComplainForm:form];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 控件事件

- (IBAction)barButtonCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)barButtonClearClick:(id)sender {
    
}

#pragma mark - 私有方法

/*!
 *  根据界面中的内容, 生成一个表单对象
 *
 *  @return 生成的表单对象
 */
- (NCPComplainForm *)generateComplainForm {
    NCPComplainForm *form = [[NCPComplainForm alloc] init];
    
    // 添加内容
    // TODO
    
    return form;
}

/*!
 *  向服务器发送投诉表单
 */
- (void)sendComplainForm:(NCPComplainForm *)form {
    NCPWebRequest *web = [NCPWebRequest requestWithPage:@"complain"];
}

/*!
 *  在本地保存此次投诉表单
 */
- (void)saveComplainForm:(NCPComplainForm *)form {
    NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
}

@end
