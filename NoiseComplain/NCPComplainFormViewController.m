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
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "NCPLog.h"

@interface NCPComplainFormViewController () <UITableViewDelegate>

#pragma mark - 输出口

@property (weak, nonatomic) IBOutlet UILabel *labelIntensity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorMeasuring;
@property (weak, nonatomic) IBOutlet UILabel *labelNoiseLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelNoiseType;
@property (weak, nonatomic) IBOutlet UILabel *labelSFAType;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;

#pragma mark - 动作事件

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

/*!
 *  定位服务
 */
@property (strong, nonatomic) BMKLocationService *locationService;

@end

@implementation NCPComplainFormViewController

#pragma mark - 生命周期事件

/*!
 *  视图初始化
 */
- (void)viewDidLoad {
    // 创建一个新的表单对象
    NCPComplainForm *form = [NCPComplainForm form];
    form.comment = @"null";
    [NCPComplainForm setCurrent:form];
}

- (void)viewWillAppear:(BOOL)animated {
    // 刷新界面
    [self displayComplainForm];
}

- (void)dealloc {
    // 删除当前的表单对象
    [NCPComplainForm setCurrent:nil];
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
            // 将投诉表单发送至服务器
            [self sendComplainForm:[NCPComplainForm current]];
            
            // 将投诉表单保存至本地
            [self saveComplainForm:[NCPComplainForm current]];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    //!!!: 删除了NCPSystemValue.h的内容
    NCPComplainForm *form = [NCPComplainForm current];
    form.longitude = [NSNumber numberWithFloat:userLocation.location.coordinate.longitude];
    form.latitude = [NSNumber numberWithFloat:userLocation.location.coordinate.latitude];
    form.altitude = [NSNumber numberWithFloat:userLocation.location.altitude];
}

#pragma mark - 动作事件

- (IBAction)barButtonCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)barButtonClearClick:(id)sender {
    
}

#pragma mark - 私有方法

- (void)displayComplainForm {
    NCPComplainForm *form = [NCPComplainForm current];
}

/*!
 *  向服务器发送投诉表单
 */
- (void)sendComplainForm:(NCPComplainForm *)form {
    // NCPWebRequest *web = [NCPWebRequest requestWithPage:@"complain"];
}

/*!
 *  在本地保存此次投诉表单
 */
- (void)saveComplainForm:(NCPComplainForm *)form {
    // NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
}

@end
