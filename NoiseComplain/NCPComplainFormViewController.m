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
    self.form = [[NCPComplainForm alloc] init];

    NSLog(@"viewDidLoad");

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

    NSLog(@"viewWillAppear");

    // 设置定位服务
    [self.locationService startUserLocationService];
}

// 视图即将消失
- (void)viewWillDisappear:(BOOL)animated {
    // 停止定位服务
    [self.locationService stopUserLocationService];

    NSLog(@"viewWillDisappear");

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
            // 将描述信息写入表单
            self.form.comment = [NSString stringWithString:self.textViewComment.text];
            // 提交投诉表单
            [self sendComplainForm];
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
                                                       self.form.noiseType = row;
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
                                                       self.form.sfaType = row;
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
    [self dismissViewControllerAnimated:YES completion:nil];
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

// 向服务器发送投诉表单
- (void)sendComplainForm {

    // 检查是否填好了所需的所有信息
    if (![self checkComplainForm]) {
        // TODO: 如果表单不完整, 中断发送
        return;
    }
    // 表单填写完整
    // TODO: 显示发送中提示框

    // 向服务器发送投诉表单
    [NCPWebService sendComplainForm:self.form
                            success:^(NSDictionary *json) {
                                // 检查返回的JSON是否包含请求成功信息
                                if (!json[@"result"] || ((NSNumber *) json[@"result"]).intValue == 0) {
                                    // TODO: 服务器请求失败
                                    return;
                                }
                                // 检查返回的JSON是否包含formId信息
                                if (!json[@"formId"] || ((NSNumber *) json[@"formId"]).longValue < 0) {
                                    // TODO: 服务器请求失败
                                    return;
                                }

                                // 包含formId信息, 投诉请求成功
                                long formId = ((NSNumber *) json[@"formId"]).longValue;
                                self.form.formId = @(formId);

                                //将投诉表单保存于本地
                                [NCPSQLiteDAO createComplainForm:self.form];

                                //TODO: 请求成功提示

                            }
                            failure:^(NSError *error) {
                                // TODO: 服务器请求失败
                            }];
}

@end
