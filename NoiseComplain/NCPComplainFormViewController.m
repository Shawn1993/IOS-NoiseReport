//
//  NCPComplainFormViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainFormViewController.h"
#import "NCPComplainForm.h"
#import "NCPNoiseRecorder.h"
#import "NCPSQLiteDAO.h"
#import "NCPWebService.h"

#import "BaiduMapAPI_Location/BMKLocationComponent.h"
#import "BaiduMapAPI_Search/BMKGeocodeSearch.h"

#import "LGAlertView.h"

#pragma mark - 常量定义

// 字符显示最大长度
static NSUInteger kNCPComplainFormCommentDisplayMaxLength = 10;

static NSString *kNCPPListFileNoiseType = @"NoiseType";
static NSString *kNCPPListFileSfaType = @"SfaType";

@interface NCPComplainFormViewController ()
        <
        UITableViewDelegate,
        UITextViewDelegate,
        BMKLocationServiceDelegate,
        BMKGeoCodeSearchDelegate
        >

#pragma mark - Storyboard输出口

// 噪声强度Section
@property(weak, nonatomic) IBOutlet UILabel *labelIntensity;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorMeasuring;

// 投诉地点Section
@property(weak, nonatomic) IBOutlet UILabel *labelNoiseLocation;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLocating;

// 噪声信息Section
@property(weak, nonatomic) IBOutlet UILabel *labelNoiseType;
@property(weak, nonatomic) IBOutlet UILabel *labelSFAType;
@property(weak, nonatomic) IBOutlet UITextView *textViewComment;
@property(weak, nonatomic) IBOutlet UILabel *labelCommentPlaceholder;
@property(weak, nonatomic) IBOutlet UITableViewCell *tableCellComment;

#pragma mark - 成员变量

// 投诉表单对象
@property(nonatomic, strong) NCPComplainForm *form;
// 噪音仪对象
@property(nonatomic) NCPNoiseRecorder *noiseRecorder;

// 定位服务
@property(nonatomic) BMKLocationService *locationService;
// 地理编码服务
@property(nonatomic) BMKGeoCodeSearch *geoCodeSearch;
// 地理编码信息
@property(nonatomic) BMKReverseGeoCodeOption *reverseGeoCodeOption;

@end


@implementation NCPComplainFormViewController

#pragma mark - ViewController生命周期

// 视图载入
- (void)viewDidLoad {
    // 创建一个新的表单对象
    self.form = [[NCPComplainForm alloc] init];

    // 开始检测噪声
    [self recordNoise];

    // 创建定位服务对象
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;

    // 创建地理编码服务对象
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.geoCodeSearch.delegate = self;

    // 创建地理编码信息对象
    self.reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
}

// 视图即将出现
- (void)viewWillAppear:(BOOL)animated {
    // 显示表格内容
    [self displayComplainForm];

    // 设置定位服务
    [self.locationService startUserLocationService];
}

// 视图即将消失
- (void)viewWillDisappear:(BOOL)animated {
    // 停止定位服务
    [self.locationService stopUserLocationService];

    // 如果键盘开启, 将其先于视图关闭
    if ([self.textViewComment isFirstResponder]) {
        [self.textViewComment resignFirstResponder];
    }
}

#pragma mark - Segue传值

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 向定位ViewController传递表单引用
    if ([segue.identifier isEqualToString:@"ComplainFormToLocation"]) {
        id dest = segue.destinationViewController;

        // 传递ComplainForm引用
        [dest setValue:self.form forKey:@"form"];
    }
}

#pragma mark - 表格点击响应

// 表格点击代理事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
            // 测量结果session, 重新检测噪声强度
            [self redetectNoise];
            break;
        case 1:
            // 噪声源位置session, 使用segue, 不做响应
            break;
        case 2:
            // 噪声源信息session
        {
            switch (indexPath.row) {
                case 0:
                    // 噪声类型
                    [self selectNoiseType];
                    break;
                case 1:
                    // 声功能区
                    [self selectSfaType];
                    break;
                default:
                    // 其他行, 不使用代码响应
                    break;
            }
        }
            break;
        case 3:
            // 提交投诉session
            [self sendComplainForm];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 重新检测噪声强度
- (void)redetectNoise {
    [self recordNoise];
}

// 选择噪声类型
- (void)selectNoiseType {
    LGAlertView *noiseSheet = [LGAlertView alertViewWithTitle:@"噪声类型选择"
                                                      message:@"请选择你要投诉的噪声类型"
                                                        style:LGAlertViewStyleActionSheet
                                                 buttonTitles:NCPReadPListArray(kNCPPListFileNoiseType)
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                                actionHandler:^(LGAlertView *alert, NSString *title, NSUInteger index) {
                                                    self.form.noiseType = title;
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self displayComplainForm];
                                                    });
                                                }
                                                cancelHandler:nil
                                           destructiveHandler:nil];
    [noiseSheet showAnimated:YES completionHandler:nil];
}

// 选择声功能区
- (void)selectSfaType {
    LGAlertView *sfaSheet = [LGAlertView alertViewWithTitle:@"环境类型选择"
                                                    message:@"请选择你当前所处的环境类型"
                                                      style:LGAlertViewStyleActionSheet
                                               buttonTitles:NCPReadPListArray(kNCPPListFileSfaType)
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                              actionHandler:^(LGAlertView *alert, NSString *title, NSUInteger index) {
                                                  self.form.sfaType = title;
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self displayComplainForm];
                                                  });
                                              }
                                              cancelHandler:nil
                                         destructiveHandler:nil];
    [sfaSheet showAnimated:YES completionHandler:nil];
}

#pragma mark - 定位功能

// 定位位置更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    self.form.longitude = @((float) userLocation.location.coordinate.longitude);
    self.form.latitude = @((float) userLocation.location.coordinate.latitude);

    // 通过坐标请求反编码，获取地址
    self.reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [self.geoCodeSearch reverseGeoCode:self.reverseGeoCodeOption];

    [self.locationService stopUserLocationService];

}

// 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error {

}

#pragma mark - 地理反编码

// 获取位置信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        self.form.address = result.address;
        [self displayComplainForm];
    }
}


#pragma mark - 文本框代理事件

// 文本框开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    // 隐藏占位符
    self.labelCommentPlaceholder.hidden = YES;

    // 屏幕上移避免被遮挡
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

// 文本框内容改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

// 文本框结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // 将文本内容传入表单对象中
    self.form.comment = [NSString stringWithString:self.textViewComment.text];

    // 检查是否需要隐藏placeHolder
    if (textView.text.length == 0) {
        self.labelCommentPlaceholder.hidden = NO;
    }
    return YES;
}

#pragma mark - 导航栏动作事件

// 取消按钮点击事件
- (IBAction)barButtonCancelClick:(id)sender {
    // 弹出确认提示框
    LGAlertView *confirmAlert = [LGAlertView alertViewWithTitle:@"提示"
                                                        message:@"投诉尚未完成, 确定要退出吗?"
                                                          style:LGAlertViewStyleAlert
                                                   buttonTitles:nil
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"退出"
                                                  actionHandler:nil
                                                  cancelHandler:nil
                                             destructiveHandler:^(LGAlertView *alert) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                 });
                                             }];
    [confirmAlert showAnimated:YES completionHandler:nil];
}

#pragma mark - 噪声测量

// 开始一次后台的噪声测量
- (void)recordNoise {
    self.noiseRecorder = [[NCPNoiseRecorder alloc] init];
    [self.noiseRecorder startWithDuration:5 timeupHandler:^(float current, float peak) {
        self.form.intensity = @(current);
        [self displayComplainForm];
        self.noiseRecorder = nil;
    }];
}

#pragma mark - 界面元素刷新

// 根据当前投诉表单的内容, 更新当前界面元素
- (void)displayComplainForm {

    // 噪声强度
    if (!self.form.intensity) {
        self.labelIntensity.text = @"测量中...";
        self.indicatorMeasuring.hidden = NO;
    } else {
        self.labelIntensity.text = [NSString stringWithFormat:@"%.1f dB", self.form.intensity.floatValue];
        self.indicatorMeasuring.hidden = YES;
    }

    // 噪声源位置
    if (!self.form.address) {
        self.labelNoiseLocation.text = @"定位中...";
        self.indicatorLocating.hidden = NO;
    } else {
        NSString *address = self.form.address;
        if (address.length > kNCPComplainFormCommentDisplayMaxLength) {
            address = [address substringWithRange:NSMakeRange(0, kNCPComplainFormCommentDisplayMaxLength)];
            address = [NSString stringWithFormat:@"%@...", address];
        }
        self.labelNoiseLocation.text = address;
        self.indicatorLocating.hidden = YES;
    }

    // 噪声类型
    if (!self.form.noiseType) {
        self.labelNoiseType.text = @"点击选择";
    } else {
        self.labelNoiseType.text = self.form.noiseType;
    }

    // 声功能区类型
    if (!self.form.sfaType) {
        self.labelSFAType.text = @"点击选择";
    } else {
        self.labelSFAType.text = self.form.sfaType;
    }
}

#pragma mark - 投诉表单发送

// 检查投诉表单是否可以发送了
- (BOOL)checkComplainForm {
    if (!self.form.intensity || self.form.intensity.floatValue == 0.0f) {
        return NO;
    } else if (!(self.form.latitude) ||
            self.form.latitude.floatValue == 0.0f ||
            !(self.form.longitude) ||
            self.form.longitude.floatValue == 0.0f) {
        return NO;
    }
    return YES;
}

// 准备发送投诉表单
- (void)sendComplainForm {
    // 检查是否填好了所需的所有信息
    if ([self checkComplainForm]) {
        // 表单填写完整, 进行发送
        [self sendCheckedComplainForm];
    } else {
        // 如果表单不完整, 中断发送
        LGAlertView *checkAlert = [LGAlertView alertViewWithTitle:@"信息不完整"
                                                          message:@"投诉信息还没有填写完整, 可能无法受理!\n是否仍然要提交投诉?"
                                                            style:LGAlertViewStyleAlert
                                                     buttonTitles:nil
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:@"提交投诉"
                                                    actionHandler:nil
                                                    cancelHandler:nil
                                               destructiveHandler:^(LGAlertView *alert) {
                                                   // 虽然信息不完整, 但是仍然发送
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [self sendCheckedComplainForm];
                                                   });
                                               }];
        [checkAlert showAnimated:YES completionHandler:nil];
    }
}

// 向服务器发送投诉表单
- (void)sendCheckedComplainForm {
    // 表单填写完整, 弹出带有提示框
    LGAlertView *sendAlert = [LGAlertView alertViewWithActivityIndicatorAndTitle:@"发送中"
                                                                         message:@"正在将投诉发送至服务器..."
                                                                           style:LGAlertViewStyleAlert
                                                                    buttonTitles:nil
                                                               cancelButtonTitle:@"取消"
                                                          destructiveButtonTitle:nil];
    [sendAlert showAnimated:YES completionHandler:nil];
    // 向服务器发送投诉表单
    [NCPWebService sendComplainForm:self.form
                            success:^(NSDictionary *json) {
                                // 检查返回的JSON是否包含请求成功信息
                                if (!json[@"result"] || ((NSNumber *) json[@"result"]).intValue == 0) {
                                    NSString *errorMessage = @"服务器数据错误!";
                                    if (json[@"errorMessage"]) {
                                        [errorMessage stringByAppendingFormat:@"\n错误: %@", errorMessage];
                                    }
                                    [self showErrorAlert:sendAlert message:errorMessage];
                                    return;
                                }
                                // 检查返回的JSON是否包含formId信息
                                if (!json[@"formId"] || ((NSNumber *) json[@"formId"]).longValue < 0) {
                                    [self showErrorAlert:sendAlert message:@"服务器数据错误!\n错误: 未返回有效的投诉表单号"];
                                    return;
                                }

                                // 包含formId信息, 投诉请求成功
                                long formId = ((NSNumber *) json[@"formId"]).longValue;
                                self.form.formId = @(formId);

                                //将投诉表单保存于本地
                                [NCPSQLiteDAO createComplainForm:self.form];

                                // 请求成功提示
                                [self showSuccessAlert:sendAlert];
                            }
                            failure:^(NSError *error) {
                                [self showErrorAlert:sendAlert
                                             message:[NSString stringWithFormat:@"服务器连接失败!\n错误: %@", error.localizedDescription]];
                            }];
}

// 显示投诉成功提示框
- (void)showSuccessAlert:(LGAlertView *)lastAlert {
    LGAlertView *successAlert = [LGAlertView alertViewWithTitle:@"投诉成功"
                                                        message:@"您的投诉已经发送至服务器!\n返回投诉列表可以查看投诉受理进度"
                                                          style:LGAlertViewStyleAlert
                                                   buttonTitles:nil
                                              cancelButtonTitle:@"返回投诉列表"
                                         destructiveButtonTitle:nil
                                                  actionHandler:nil
                                                  cancelHandler:^(LGAlertView *alert) {
                                                      // 关闭当前投诉页面
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                      });
                                                  }
                                             destructiveHandler:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (lastAlert && lastAlert.isShowing) {
            // 如果有正在显示的提示框
            [lastAlert transitionToAlertView:successAlert completionHandler:nil];
        } else {
            // 开启新的提示框
            [successAlert showAnimated:YES completionHandler:nil];
        }
    });
}

// 显示投诉错误提示框
- (void)showErrorAlert:(LGAlertView *)lastAlert message:(NSString *)message {
    // 显示错误提示
    LGAlertView *errorAlert = [LGAlertView alertViewWithTitle:@"投诉失败"
                                                      message:message
                                                        style:LGAlertViewStyleAlert
                                                 buttonTitles:nil
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (lastAlert && lastAlert.isShowing) {
            // 如果有正在显示的提示框
            [lastAlert transitionToAlertView:errorAlert completionHandler:nil];
        } else {
            // 开启新的提示框
            [errorAlert showAnimated:YES completionHandler:nil];
        }
    });
}

@end
