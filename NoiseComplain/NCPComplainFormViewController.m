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
#import "NCPNoiseRecorder.h"
#import "NCPSQLiteDAO.h"

#import "BaiduMapAPI_Location/BMKLocationComponent.h"
#import "BaiduMapAPI_Search/BMKGeocodeSearch.h"

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

// 噪音仪对象
@property(nonatomic) NCPNoiseRecorder *noiseRecorder;

// 导航栏按钮Cancel
- (IBAction)barButtonCancelClick:(id)sender;

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
    [NCPComplainForm setCurrent:[NCPComplainForm form]];

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

// 视图即将析构
- (void)viewWillUnload {
    [NCPComplainForm setCurrent:nil];
    self.noiseRecorder = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearch.delegate = nil;
}

#pragma mark - 表格点击事件

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
        {
            NCPComplainForm *form = [NCPComplainForm current];
            // 将描述信息写入表单
            form.comment = [NSString stringWithString:self.textViewComment.text];
            // 提交投诉表单
            [self sendComplainForm:form];
        }
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
    NSArray *array = NCPReadPListArray(kNCPPListFileNoiseType);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"噪声类型选择"
                                                                message:@"请选择你要投诉的噪声类型"
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *row in array) {
        UIAlertAction *aa = [UIAlertAction actionWithTitle:row
                                                     style:UIAlertActionStyleDefault
                                                   handler:(void (^)(UIAlertAction *)) ^{
                                                       NCPComplainForm *form = [NCPComplainForm current];
                                                       form.noiseType = row;
                                                       [self displayComplainForm];
                                                   }];
        [ac addAction:aa];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

// 选择声功能区
- (void)selectSfaType {
    NSArray *array = NCPReadPListArray(kNCPPListFileSfaType);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"环境类型选择"
                                                                message:@"请选择你当前所处的环境类型"
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *row in array) {
        UIAlertAction *aa = [UIAlertAction actionWithTitle:row
                                                     style:UIAlertActionStyleDefault
                                                   handler:(void (^)(UIAlertAction *)) ^{
                                                       NCPComplainForm *form = [NCPComplainForm current];
                                                       form.sfaType = row;
                                                       [self displayComplainForm];
                                                   }];
        [ac addAction:aa];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 定位功能

// 定位位置更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NCPComplainForm *form = [NCPComplainForm current];
    form.longitude = @((float) userLocation.location.coordinate.longitude);
    form.latitude = @((float) userLocation.location.coordinate.latitude);

    // 通过坐标请求反编码，获取地址
    self.reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [self.geoCodeSearch reverseGeoCode:self.reverseGeoCodeOption];

    [self.locationService stopUserLocationService];

}

// 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error {

}

#pragma mark - 地理反编码功能

// 获取位置信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        NCPComplainForm *form = [NCPComplainForm current];
        form.address = result.address;
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
    [NCPComplainForm current].comment = [NSString stringWithString:self.textViewComment.text];

    // 检查是否需要隐藏placeHolder
    if (textView.text.length == 0) {
        self.labelCommentPlaceholder.hidden = NO;
    }
    return YES;
}

#pragma mark - 导航栏动作事件

// 取消按钮点击事件
- (IBAction)barButtonCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 其他私有方法

// 开始一次后台的噪声测量
- (void)recordNoise {
    self.noiseRecorder = [[NCPNoiseRecorder alloc] init];
    [self.noiseRecorder startWithDuration:5 timeupHandler:^(float current, float peak) {
        [NCPComplainForm current].intensity = @(current);
        [self displayComplainForm];
        self.noiseRecorder = nil;
    }];
}

// 根据当前投诉表单的内容, 更新当前界面
- (void)displayComplainForm {
    NCPComplainForm *form = [NCPComplainForm current];

    // 噪声强度
    if (!form.intensity) {
        self.labelIntensity.text = @"测量中...";
        self.indicatorMeasuring.hidden = NO;
    } else {
        self.labelIntensity.text = [NSString stringWithFormat:@"%.1f dB", form.intensity.floatValue];
        self.indicatorMeasuring.hidden = YES;
    }

    // 噪声源位置
    if (!form.address) {
        self.labelNoiseLocation.text = @"定位中...";
        self.indicatorLocating.hidden = NO;
    } else {
        NSString *address = form.address;
        if (address.length > kNCPComplainFormCommentDisplayMaxLength) {
            address = [address substringWithRange:NSMakeRange(0, kNCPComplainFormCommentDisplayMaxLength)];
            address = [NSString stringWithFormat:@"%@...", address];
        }
        self.labelNoiseLocation.text = address;
        self.indicatorLocating.hidden = YES;
    }

    // 噪声类型
    if (!form.noiseType) {
        self.labelNoiseType.text = @"点击选择";
    } else {
        self.labelNoiseType.text = form.noiseType;
    }

    // 声功能区类型
    if (!form.sfaType) {
        self.labelSFAType.text = @"点击选择";
    } else {
        self.labelSFAType.text = form.sfaType;
    }
}

// 向服务器发送投诉表单
- (void)sendComplainForm:(NCPComplainForm *)form {

    // 检查是否填好了所需的所有信息
    NSString *missing;
    if (!form.intensity || form.intensity.floatValue == 0.0f) {
        missing = @"请等待噪声强度测量完毕...";
    } else if (!(form.latitude) || form.latitude.floatValue == 0.0f || !(form.longitude) || form.longitude.floatValue == 0.0f) {
        missing = @"请等待定位完成，或手动选择投诉地点...";
    }

    if (missing) {
        // 如果发现有缺失的必要信息, 进行提示
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"投诉信息不完整"
                                                                    message:missing
                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *aa = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:aa];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }

    // 显示提示框
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"正在提交投诉中..."
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];

    // TODO: 使用网络框架

    // 组织网络请求
    NCPWebRequest *web = [NCPWebRequest requestWithPage:@"complain"];
    [web addParameter:@"devId" withString:form.devId];
    [web addParameter:@"comment" withString:form.comment];
    [web addParameter:@"date" withString:NCPStringFormDate(form.date)];
    [web addParameter:@"intensity" withFloat:form.intensity.floatValue];
    [web addParameter:@"address" withString:form.address];
    [web addParameter:@"latitude" withFloat:form.latitude.floatValue];
    [web addParameter:@"longitude" withFloat:form.longitude.floatValue];
    [web addParameter:@"coord" withString:form.coord];
    [web addParameter:@"sfaType" withString:form.sfaType];
    [web addParameter:@"noiseType" withString:form.noiseType];

    // 发送网络请求
    [web sendWithCompletionHandler:^(NSDictionary *json, NSError *error) {
        NSString *errStr;
        if (json) {
            NSLog(@"Return JSON: %@", json);
            // 如果请求成功, 将投诉表单保存至本地
            if (json[@"result"] &&
                    ((NSNumber *) json[@"result"]).intValue != 0 &&
                    json[@"formId"] &&
                    ((NSNumber *) json[@"formId"]).intValue) {
                form.formId = @(((NSNumber *) json[@"formId"]).longValue);
                [NCPSQLiteDAO createComplainForm:form];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 投诉成功, 关闭页面
                    [ac dismissViewControllerAnimated:YES completion:^{
                        UIAlertController *fac = [UIAlertController alertControllerWithTitle:@"投诉成功"
                                                                                     message:@"您的投诉已经成功发送!"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *finish = [UIAlertAction actionWithTitle:@"确定"
                                                                         style:UIAlertActionStyleCancel
                                                                       handler:(void (^)(UIAlertAction *)) ^{
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                                           });
                                                                       }];
                        [fac addAction:finish];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:fac animated:YES completion:nil];
                        });
                    }];
                });
            }
            else {
                errStr = @"服务器返回数据异常";
            }
        } else {
            errStr = [NSString stringWithFormat:@"网络连接异常: %@", error.localizedDescription];
        }
        if (errStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 如果请求出现错误, 进行提示
                [ac dismissViewControllerAnimated:YES completion:^{
                    UIAlertController *eac = [UIAlertController alertControllerWithTitle:@"投诉失败"
                                                                                 message:errStr
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [eac addAction:cancel];
                    [self presentViewController:eac animated:YES completion:nil];
                }];
            });
        }
    }];
}

@end
