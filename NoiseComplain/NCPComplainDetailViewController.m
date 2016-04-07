//
//  NCPComplainDetailViewController.m
//  NoiseComplain
//
//  Created by mura on 3/27/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPComplainDetailViewController.h"
#import "NCPComplainForm.h"

#pragma mark - 常量定义

// 当某个值不存在时, 显示的值
static NSString *kNCPNullString = @"未知";

// 日期格式字符串
static NSString *kNCPDateFormat = @"yyyy-MM-dd HH:mm:ss";

@interface NCPComplainDetailViewController ()

#pragma mark - Storyboard输出口

// 各种UILabel
@property(weak, nonatomic) IBOutlet UILabel *labelProcess;
@property(weak, nonatomic) IBOutlet UILabel *labelFormId;
@property(weak, nonatomic) IBOutlet UILabel *labelDate;
@property(weak, nonatomic) IBOutlet UILabel *labelAverageIntensity;
@property(weak, nonatomic) IBOutlet UILabel *labelAddress;
@property(weak, nonatomic) IBOutlet UILabel *labelNoiseType;
@property(weak, nonatomic) IBOutlet UILabel *labelSfaType;

// 进度TableView
@property (weak, nonatomic) IBOutlet UITableView *tableViewProcess;

// 进度数组
@property (nonatomic) NSMutableArray *processes;

@end

@implementation NCPComplainDetailViewController

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
    self.labelFormId.text = self.form.formId ?
            [NSString stringWithFormat:@"%li", self.form.formId.longValue] :
            kNCPNullString;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = kNCPDateFormat;
    self.labelDate.text = self.form.date ?
            [df stringFromDate:self.form.date] :
            kNCPNullString;
    self.labelAverageIntensity.text = self.form.averageIntensity > 0.0 ?
            [NSString stringWithFormat:@"%.2f dB", self.form.averageIntensity] :
            kNCPNullString;
    self.labelAddress.text = self.form.address ? self.form.address : kNCPNullString;
    self.labelNoiseType.text = self.form.noiseType ? self.form.noiseTypeShort : kNCPNullString;
    self.labelSfaType.text = self.form.sfaType ? self.form.sfaTypeShort : kNCPNullString;
}

// 设置表格Footer
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 3) {
        // 只修改投诉描述Section的Footer
        if (!self.form.comment || self.form.comment.length == 0) {
            // 没有描述信息
            return @"没有写文字描述...";
        } else {
            return [NSString stringWithFormat:@"文字描述:\n%@", self.form.comment];
        }
    }
    return [super tableView:tableView titleForFooterInSection:section];
}

#pragma mark - 表格点击事件

// 表格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
