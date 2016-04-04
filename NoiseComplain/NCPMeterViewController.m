//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseRecorder.h"
#import "NCPMeterView.h"
#import "NCPGraphView.h"

@interface NCPMeterViewController ()

#pragma mark - Storyboard输出口

// 噪声仪表View
@property(weak, nonatomic) IBOutlet NCPMeterView *meterView;
// 噪声曲线图View
@property(weak, nonatomic) IBOutlet NCPGraphView *graphView;

#pragma mark - 成员变量

@property(nonatomic, strong) NCPNoiseRecorder *recorder;

@end

@implementation NCPMeterViewController

#pragma mark - ViewController生命周期

// 视图载入完成
- (void)viewDidLoad {
    [super viewDidLoad];

    // 清除Storyboard中View的背景颜色
    self.meterView.backgroundColor = [UIColor clearColor];
    self.graphView.backgroundColor = [UIColor clearColor];
}

// 视图即将出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 初始化录音器
    self.recorder = [[NCPNoiseRecorder alloc] init];
    const int j = (const int) (NCPConfigDouble(@"MeterVCRefreshPerSecond") / NCPConfigDouble(@"MeterVCRefreshLabelPerSecond"));
    [self.recorder startWithTick:1.0f / NCPConfigDouble(@"MeterVCRefreshPerSecond") tickHandler:^(double current, double peak) {
        static int i = 0;
        if (++i > j) {
            i = 0;
            [self.meterView setValueWithLable:current];
        } else {
            self.meterView.value = current;
        }
        [self.graphView addValue:current];
    }];
}

// 视图即将消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 停止录音器
    [self.recorder stop];
    self.recorder = nil;
}


// 测试临时方法
- (IBAction)Test:(id)sender {
    // 测试代码
    NSLog(@"Test!");
}

@end
