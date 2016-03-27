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
#import "NCPSQLiteDAO.h"

#import "FMDB.h"

@interface NCPMeterViewController ()

#pragma mark - 成员变量

@property(nonatomic, strong) NCPNoiseRecorder *recorder;

#pragma mark - Storyboard输出口

@property(weak, nonatomic) IBOutlet NCPMeterView *meterView;
@property(weak, nonatomic) IBOutlet NCPGraphView *graphView;

@end

@implementation NCPMeterViewController

#pragma mark - ViewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    // 清除自定义View的背景颜色
    self.meterView.backgroundColor = [UIColor clearColor];
    self.graphView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 初始化录音器
    self.recorder = [[NCPNoiseRecorder alloc] init];
    [self.recorder startWithTick:1.0f / 30.0f tickHandler:^(float current, float peak) {
        static int i = 0;
        if (i++ > 10) {
            i = 0;
            [self.meterView setValueWithLable:current];
        } else {
            self.meterView.value = current;
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 停止录音器
    [self.recorder stop];
    self.recorder = nil;
}

- (IBAction)Test:(id)sender {
    // 测试代码
    NSLog(@"Test!");
}

@end
