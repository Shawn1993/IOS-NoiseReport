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

// 打开地图ViewController的Segue标识符
static NSString *kNCPSegueIdToLocation = @"ComplainFormToLocation";

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
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorRecording;

// 投诉地点Section
@property(weak, nonatomic) IBOutlet UILabel *labelLocatingStatus;

// 噪声信息Section
@property(weak, nonatomic) IBOutlet UILabel *labelNoiseType;
@property(weak, nonatomic) IBOutlet UILabel *labelSFAType;
@property(weak, nonatomic) IBOutlet UITextView *textViewComment;
@property(weak, nonatomic) IBOutlet UILabel *labelCommentPlaceholder;

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

// 自动定位失败标识符
@property(nonatomic) BOOL autoLocatingFailed;

@end


@implementation NCPComplainFormViewController

#pragma mark - ViewController生命周期

// 视图载入
- (void)viewDidLoad {
    // 创建一个新的表单对象
    self.form = [[NCPComplainForm alloc] init];

    // 开始检测噪声
    [self startRecord];

    // 创建定位服务对象
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;

    // 创建地理编码服务对象
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.geoCodeSearch.delegate = self;

    // 创建地理编码信息对象
    self.reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];

    // 设置定位服务
    [self.locationService startUserLocationService];
    self.autoLocatingFailed = NO;
}

// 视图即将出现
- (void)viewWillAppear:(BOOL)animated {
    // 刷新表格内容
    [self displayComplainForm];
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

#pragma mark - 导航栏动作事件

// 取消按钮点击事件
- (IBAction)barButtonCancelClick:(id)sender {
    // 关闭键盘
    if ([self.textViewComment isFirstResponder]) {
        [self.textViewComment resignFirstResponder];
    }

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

#pragma mark - Segue传值

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 向定位ViewController传递表单引用
    if ([segue.identifier isEqualToString:kNCPSegueIdToLocation]) {
        // 如果是去向定位视图
        id dest = segue.destinationViewController;
        [dest setValue:self.form forKey:@"form"];
    }
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - 表格点击事件

// 表格点击代理事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 关闭键盘
    if ([self.textViewComment isFirstResponder]) {
        [self.textViewComment resignFirstResponder];
    }

    switch (indexPath.section) {
        case 0:
            // 测量结果session, 重新检测噪声强度
            [self.form.intensities removeAllObjects];
            [self displayComplainForm];
            [self startRecord];
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

// 选择噪声类型
- (void)selectNoiseType {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"NoiseTypePList"));
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:types.count];
    for (NSUInteger i = 0; i < types.count; i++) {
        [titles addObject:((NSDictionary *) types[i])[@"title"]];
    }
    LGAlertView *noiseSheet = [LGAlertView alertViewWithTitle:@"噪声类型选择"
                                                      message:@"请选择你要投诉的噪声类型"
                                                        style:LGAlertViewStyleActionSheet
                                                 buttonTitles:titles
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                                actionHandler:^(LGAlertView *alert, NSString *title, NSUInteger index) {
                                                    int i = -1;
                                                    for (NSDictionary *type in types) {
                                                        if ([((NSString *) type[@"title"]) isEqualToString:title]) {
                                                            i = ((NSNumber *) type[@"index"]).intValue;
                                                        }
                                                    }
                                                    self.form.noiseType = (NSUInteger) i;
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
    NSArray *types = NCPReadPListArray(NCPConfigString(@"SfaTypePList"));
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:types.count];
    for (NSUInteger i = 0; i < types.count; i++) {
        [titles addObject:((NSDictionary *)types[i])[@"title"]];
    }
    LGAlertView *sfaSheet = [LGAlertView alertViewWithTitle:@"环境类型选择"
                                                    message:@"请选择你当前所处的环境类型"
                                                      style:LGAlertViewStyleActionSheet
                                               buttonTitles:titles
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                              actionHandler:^(LGAlertView *alert, NSString *title, NSUInteger index) {
                                                  int i = -1;
                                                  for (NSDictionary *type in types) {
                                                      if ([((NSString *) type[@"title"]) isEqualToString:title]) {
                                                          i = ((NSNumber *) type[@"index"]).intValue;
                                                      }
                                                  }
                                                  self.form.sfaType = (NSUInteger) i;
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
    self.form.autoLongitude = @(userLocation.location.coordinate.longitude);
    self.form.autoLatitude = @(userLocation.location.coordinate.latitude);
    self.form.autoAltitude = @(userLocation.location.altitude);

    self.form.autoHorizontalAccuracy = @(userLocation.location.horizontalAccuracy);
    self.form.autoVerticalAccuracy = @(userLocation.location.verticalAccuracy);

    // 通过坐标请求反编码，获取地址
    self.reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [self.geoCodeSearch reverseGeoCode:self.reverseGeoCodeOption];

    // 停止定位服务
    [self.locationService stopUserLocationService];
}

// 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error {
    self.autoLocatingFailed = YES;
    [self displayComplainForm];
}

// 地理位置反编码(获取位置描述)
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        self.form.autoAddress = result.address;
        // 刷新定位状态与显示
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

#pragma mark - 噪声测量功能

// 开始一次后台的噪声测量
- (void)startRecord {

    // 检查当前是否已经有正在进行的录音器
    if (self.noiseRecorder && self.noiseRecorder.isRecording) {
        [self.noiseRecorder stop];
    }

    self.noiseRecorder = [[NCPNoiseRecorder alloc] init];
    [self.noiseRecorder startWithTick:NCPConfigDouble(@"RecorderIntensityInterval")
                          tickHandler:^(double current, double peak) {
                              // 将噪声记录添加至表单
                              [self.form addIntensity:current];

                              // 检查噪声记录是否有足够的数量
                              if (self.form.isIntensitiesFull) {
                                  // 结束测量
                                  [self displayComplainForm];
                                  [self.noiseRecorder stop];
                                  self.noiseRecorder = nil;
                              }
                          }];
}

#pragma mark - 界面元素刷新

// 根据当前投诉表单的内容, 更新当前界面元素
- (void)displayComplainForm {

    // 噪声强度
    if (!self.form.isIntensitiesFull) {
        self.labelIntensity.text = @"测量中...";
        self.indicatorRecording.hidden = NO;
    } else {
        self.labelIntensity.text = [NSString stringWithFormat:@"%.2f dB", self.form.averageIntensity];
        self.indicatorRecording.hidden = YES;
    }

    // 检查是否有定位结果
    if (self.form.address) {
        // 检查定位状态
        if (self.form.manualAddress) {
            // 是手动定位结果
            self.labelLocatingStatus.text = @"使用自定义地点";
        } else {
            // 是自冬=动定位结果
            self.labelLocatingStatus.text = @"自动定位完成";
        }
        [self.tableView reloadData];
    } else {
        // 没有定位结果
        if (self.autoLocatingFailed) {
            // 自动定位失败
            self.labelLocatingStatus.text = @"自动定位失败";
        } else {
            // 仍然在自动定位中
            self.labelLocatingStatus.text = @"定位中...";
        }
    }

    // 噪声类型
    if (!self.form.noiseType) {
        self.labelNoiseType.text = @"点击选择";
    } else {
        self.labelNoiseType.text = self.form.noiseTypeShort;
    }

    // 声功能区类型
    if (!self.form.sfaType) {
        self.labelSFAType.text = @"点击选择";
    } else {
        self.labelSFAType.text = self.form.sfaTypeShort;
    }
}

// 为Section提供FooterView
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    // 只改变投诉地点的Footer
    if (section == 1) {
        // 只在有定位结果的时候显示
        if (self.form.address) {
            return self.form.address;
        }
    }
    return [super tableView:tableView titleForFooterInSection:section];
}

#pragma mark - 投诉表单发送

// 检查投诉表单是否可以发送了
- (BOOL)checkComplainForm {
    if (!self.form.isIntensitiesFull) {
        // 噪声检测还没有完成
        return NO;
    } else if (!self.form.autoAddress && !self.form.manualAddress) {
        // 没有选择位置
        return NO;
    } else if (!self.form.noiseType || !self.form.sfaType) {
        // 没有选择噪声或声功能区类型
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
                                // 检查返回的JSON是否包含formId信息
                                if (!json[@"formId"] || ((NSNumber *) json[@"formId"]).longValue < 0) {
                                    [self showErrorAlert:sendAlert message:@"服务器返回数据错误!\n错误: 未返回有效的投诉表单号"];
                                    return;
                                }

                                // 包含formId信息, 投诉请求成功
                                long formId = ((NSNumber *) json[@"formId"]).longValue;
                                self.form.formId = @(formId);

                                //将投诉表单保存于本地
                                [NCPSQLiteDAO insertComplainForm:self.form];

                                // 请求成功提示
                                [self showSuccessAlert:sendAlert];
                            }
                            failure:^(NSString *error) {
                                [self showErrorAlert:sendAlert
                                             message:[NSString stringWithFormat:@"与服务器通信失败!\n%@", error]];
                            }];
}

// 显示投诉成功提示框
- (void)showSuccessAlert:(LGAlertView *)lastAlert {
    LGAlertView *successAlert = [LGAlertView alertViewWithTitle:@"投诉成功"
                                                        message:@"您的投诉已经发送至服务器!\n返回投诉列表可以查看投诉受理进度"
                                                          style:LGAlertViewStyleAlert
                                                   buttonTitles:@[@"返回列表"]
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                                  actionHandler:^(LGAlertView *alert, NSString *title, NSUInteger index) {
                                                      // 关闭当前投诉页面
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                      });
                                                  }
                                                  cancelHandler:nil
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
                                                 buttonTitles:@[@"返回列表"]
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                                actionHandler:^(LGAlertView *alert, NSString *title, NSUInteger index) {
                                                    // 关闭当前投诉页面
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    });
                                                }
                                                cancelHandler:nil
                                           destructiveHandler:nil];

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
