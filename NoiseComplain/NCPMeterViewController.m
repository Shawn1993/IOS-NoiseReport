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

@property(nonatomic, strong) NCPNoiseRecorder *recorder;

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


- (IBAction)test1:(id)sender {
    self.meterView.value = self.meterView.value + 1;
}

- (IBAction)test2:(id)sender {
    self.meterView.value = self.meterView.value - 1;
}

@end
