//
//  NCPComplainDetailViewController.m
//  NoiseComplain
//
//  Created by mura on 3/27/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPDetailViewController.h"
#import "NCPComplainForm.h"
#import "LGAlertView.h"

#pragma mark - 常量定义

// 当某个值不存在时, 显示的值
static NSString *const kNCPNullString = @"未知";

@interface NCPDetailViewController ()

#pragma mark - Storyboard输出口

// 各种UILabel
@property(weak, nonatomic) IBOutlet UILabel *labelFormId;
@property(weak, nonatomic) IBOutlet UILabel *labelDate;
@property(weak, nonatomic) IBOutlet UILabel *labelAverageIntensity;
@property(weak, nonatomic) IBOutlet UILabel *labelAddress;
@property(weak, nonatomic) IBOutlet UILabel *labelNoiseType;
@property(weak, nonatomic) IBOutlet UILabel *labelSfaType;
@property(weak, nonatomic) IBOutlet UITextView *textViewComment;

@end

@implementation NCPDetailViewController

#pragma mark - ViewController生命周期

// 视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    // 载入ComplainForm
    [self displayComplainForm];
    [super viewWillAppear:animated];
}

#pragma mark - 界面元素刷新

// 使用投诉表单的内容刷新界面元素
- (void)displayComplainForm {
    // 设置各个Label的内容
    self.labelFormId.text = self.form.formId ?
            [NSString stringWithFormat:@"%li", self.form.formId.longValue] :
            kNCPNullString;
    self.labelDate.text = self.form.date ?
            self.form.dateLong :
            kNCPNullString;
    self.labelAverageIntensity.text = self.form.averageIntensity > 0.0 ?
            [NSString stringWithFormat:@"%.2f dB", self.form.averageIntensity] :
            kNCPNullString;
    self.labelAddress.text = self.form.address ? self.form.address : kNCPNullString;
    self.labelNoiseType.text = self.form.noiseType ? self.form.noiseTypeShort : kNCPNullString;
    self.labelSfaType.text = self.form.sfaType ? self.form.sfaTypeShort : kNCPNullString;

    // 设置Comment的内容
    self.textViewComment.text = self.form.comment;
}

#pragma mark - 表格视图相关

// 表格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        // 如果是点击了投诉地址节
        NSMutableString *message = [NSMutableString string];
        // 显示地址详情
        [message appendFormat:@"%@\n", self.form.address];
        [message appendFormat:@"纬度：%.2f ", self.form.latitude.doubleValue];
        [message appendFormat:@"经度：%.2f", self.form.longitude.doubleValue];
        LGAlertView *alert = [LGAlertView alertViewWithTitle:@"投诉地点详情"
                                                     message:message
                                                       style:LGAlertViewStyleAlert
                                                buttonTitles:nil
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil];
        [alert showAnimated:YES completionHandler:nil];
    }
    // 取消焦点
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
