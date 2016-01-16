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
#import "BaiduMapAPI_Location/BMKLocationComponent.h"
#import "NCPLog.h"
#import "NCPNoiseRecorder.h"

static NSUInteger kNCPComplainFormCommentDisplayMaxLength = 10;

@interface NCPComplainFormViewController () <UITableViewDelegate, NCPNoiseRecorderDelegate, UITextFieldDelegate, UITextViewDelegate>

/*!各输出口*/
@property (weak, nonatomic) IBOutlet UILabel *labelIntensity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorMeasuring;
@property (weak, nonatomic) IBOutlet UILabel *labelNoiseLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelNoiseType;
@property (weak, nonatomic) IBOutlet UILabel *labelSFAType;

@property (weak, nonatomic) IBOutlet UILabel *labelCommentPlaceholder;

/*!噪音仪对象*/
@property (nonatomic) NCPNoiseRecorder *noiseRecorder;

/*!导航栏按钮Cancel*/
- (IBAction)barButtonCancelClick:(id)sender;

/*!定位服务*/
@property (nonatomic) BMKLocationService *locationService;

/*!警告控制器*/
@property (nonatomic) UIAlertController *alertController;
@property (nonatomic) NSNumber *sendFinish;

@end

@implementation NCPComplainFormViewController

#pragma mark - 生命周期事件

/*!视图即将初始化*/
- (void)viewDidLoad {
    // 创建一个新的表单对象
    [NCPComplainForm setCurrent:[NCPComplainForm form]];
    self.noiseRecorder = [[NCPNoiseRecorder alloc] init];
    self.noiseRecorder.delegate = self;
    [self.noiseRecorder startWithDuration:5];
}

/*!视图初始化完成*/
- (void)viewWillAppear:(BOOL)animated {
    self.noiseRecorder.delegate = self;
    [self displayComplainForm];
}

/*!视图即将消失*/
- (void)viewWillDisAppear:(BOOL)animated{
    self.noiseRecorder.delegate = nil;
}

/*!析构*/
- (void)dealloc {
    [NCPComplainForm setCurrent:nil];
}

#pragma mark - NCPNoiseRecorderDelegate

- (void)willStartRecording{
    self.indicatorMeasuring.hidden = NO;
    self.labelIntensity.text = @"测量中";
}

- (void)didUpdateAveragePower:(NCPPower)averagePower PeakPower:(NCPPower)peakPower {
    self.indicatorMeasuring.hidden = YES;
    self.labelIntensity.text = [NSString stringWithFormat:@"%.1f dB",averagePower];
    [NCPComplainForm current].intensity = [NSNumber numberWithFloat:averagePower];
}

- (void)didStopRecording{
    
}

#pragma mark - UITableView数据源协议与代理协议

/*!表格选择代理方法*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            // 测量结果session
            [self.noiseRecorder startWithDuration:5];
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
            NCPComplainForm *form = [NCPComplainForm current];
            // 将投诉表单发送至服务器
            [self sendComplainForm:form];
            // 将投诉表单保存至本地
            [self saveComplainForm:form];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NCPComplainForm *form = [NCPComplainForm current];
    form.longitude = [NSNumber numberWithFloat:userLocation.location.coordinate.longitude];
    form.latitude = [NSNumber numberWithFloat:userLocation.location.coordinate.latitude];
    form.altitude = [NSNumber numberWithFloat:userLocation.location.altitude];
}

#pragma mark - UITextViewDelegate

/*!文本框开始编辑*/
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.labelCommentPlaceholder.hidden = YES;
}

/*!文本框结束编辑*/
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    // 检查是否需要隐藏placeHolder
    if (textView.text.length == 0) {
        self.labelCommentPlaceholder.hidden = NO;
    }
    
    // 将结果写入表单
    [NCPComplainForm current].comment = textView.text;
}

/*!文本框输入文字*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
 
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 动作事件

- (IBAction)barButtonCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法

/*!将投诉表单的内容显示在界面上*/
- (void)displayComplainForm
{
    NCPComplainForm *form = [NCPComplainForm current];
    
    // 噪声强度
    if (!form.intensity) {
        self.labelIntensity.text = @"测量中";
    } else {
        self.labelIntensity.text = [NSString stringWithFormat:@"%.1f dB", form.intensity.floatValue];
    }
    
    // 噪声源位置
    if (!form.address) {
        self.labelNoiseLocation.text = @"使用当前位置";
    } else {
        NSString *address = form.address;
        if (address.length > kNCPComplainFormCommentDisplayMaxLength) {
            address = [address substringWithRange:NSMakeRange(0, kNCPComplainFormCommentDisplayMaxLength)];
            address = [NSString stringWithFormat:@"%@...", address];
        }
        self.labelNoiseLocation.text = address;
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

/*!向服务器发送投诉表单*/
- (void)sendComplainForm:(NCPComplainForm *)form {
    
    // 显示提示框
    self.alertController = [UIAlertController alertControllerWithTitle:@"在为你提交投诉中"
                                                               message:@"请稍后"
                                                        preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:self.alertController animated:YES completion:nil];
    
    // 组织网络请求
    NCPWebRequest *web = [NCPWebRequest requestWithPage:@"complain"];
    [web addParameter:@"comment" withString:form.address];
    [web addParameter:@"date" withString:[NSString stringWithFormat:@"%@", form.date]];
    [web addParameter:@"intensity" withFloat:form.intensity.floatValue];
    [web addParameter:@"address" withString:form.address];
    [web addParameter:@"latitude" withFloat:form.latitude.floatValue];
    [web addParameter:@"longitude"  withFloat:form.longitude.floatValue];
    [web addParameter:@"image" withData:form.image];
    [web addParameter:@"sfaType" withString:form.sfaType];
    [web addParameter:@"noiseType" withString:form.noiseType];
    
    // 发送网络请求
    [web sendWithCompletionHandler:^(NSDictionary *json) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
        NCPLogInfo(@"%@", json);
    }];
}

/*!在本地保存此次投诉表单*/
- (void)saveComplainForm:(NCPComplainForm *)form {
    // NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
}

@end
