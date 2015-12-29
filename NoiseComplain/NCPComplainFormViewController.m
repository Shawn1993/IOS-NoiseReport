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
#import "NCPSystemValue.h"

@interface NCPComplainFormViewController () <UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>

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

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (strong,nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) BMKLocationService *locationService;

@end

@implementation NCPComplainFormViewController

#pragma mark - 生命周期事件

/*!
 *  视图初始化
 */
- (void)viewDidLoad {
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    [self.mapViewContainer addSubview:self.mapView];
    self.mapView.userTrackingMode =BMKUserTrackingModeFollow;

    
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    [self.locationService startUserLocationService];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    NSLog(@"%f %f",self.mapViewContainer.bounds.size.width,self.mapViewContainer.bounds.size.height);
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    self.mapView.frame = self.mapViewContainer.bounds;
    NSLog(@"%f %f",self.mapViewContainer.bounds.size.width,self.mapViewContainer.bounds.size.height);
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
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

#pragma mark - BMKMapViewDelegate


#pragma mark - BMKLocationServiceDelegate

-(void)willStartLocatingUser{
    NSLog(@"开始定位");
    
}

-(void)didStopLocatingUser{
    NSLog(@"结束定位");
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    if (!userLocation.location)
        return;
    [self.mapView updateLocationData:userLocation];
    NCPCurrentLatitude = userLocation.location.coordinate.latitude;
    NCPCurrentLongtitude = userLocation.location.coordinate.longitude;
    
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败");
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
