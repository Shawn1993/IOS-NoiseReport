//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseMeter.h"
#import "NCPNoiseRecorder.h"
#import "NCPDashboardView.h"
#import "NCPArrowView.h"
#import "NCPLog.h"

// 屏幕大小
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define ARROW_LENGTH 140
#define ARROW_WIDTH 10

@interface NCPMeterViewController () <NCPNoiseRecorderDelegate> {
    NSTimer *mTimer;
    NCPNoiseMeter *mNoiseMeter;
    double mValueSPL;
}

@property(weak, nonatomic) IBOutlet NCPDashboardView *dashboardView;

@property(weak, nonatomic) IBOutlet UILabel *labelSPL;

@property(weak, nonatomic) IBOutlet NCPGraphView *graphView;

@property(weak, nonatomic) IBOutlet UIButton *btnRecord;

@property(weak, nonatomic) IBOutlet UILabel *recordLabel;

@property(nonatomic) UIView *recordingAlertView;

@property(nonatomic) UIView *recordingRevokeView;

@property(nonatomic) NCPNoiseRecorder *noiseRecorder;

@end

@implementation NCPMeterViewController

#pragma mark - 生命周期

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad {

    [super viewDidLoad];
    [self initView];

    self.noiseRecorder = [[NCPNoiseRecorder alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [self initNoiseMeter];
    self.btnRecord.titleLabel.text = @"松开结束";
    self.noiseRecorder.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.noiseRecorder.delegate = nil;

    if (mNoiseMeter) {
        [mNoiseMeter stop];
        mNoiseMeter = nil;
    }
}

#pragma mark - 初始化方法

- (void)initView {
    [self.btnRecord addTarget:self action:@selector(touchDownBtnRecord:) forControlEvents:UIControlEventTouchDown];
    [self.btnRecord addTarget:self action:@selector(touchUpInsideBtnRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord addTarget:self action:@selector(touchUpOutsideBtnRecord:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnRecord addTarget:self action:@selector(dragExitBtnRecord:) forControlEvents:UIControlEventTouchDragExit];
    [self.btnRecord addTarget:self action:@selector(dragEnterBtnRecord:) forControlEvents:UIControlEventTouchDragEnter];
}


- (void)initNoiseMeter {

    mNoiseMeter = [[NCPNoiseMeter alloc] init];

    [mNoiseMeter startWithCallback:^{

        mValueSPL = mNoiseMeter.lastAvg + 120;

        self.labelSPL.text = [NSString stringWithFormat:@"%d", (int) (mValueSPL)];

        [self.graphView addValue:mValueSPL];

        [self.dashboardView showValue:mValueSPL];
    }];
}


#pragma mark - btnRecord Action

- (void)touchDownBtnRecord:(id)sender {
    [self.noiseRecorder start];
    [self showRecordingView];
    NSLog(@"touchDownBtnRecord");
    self.recordLabel.text = @"松开结束";
}

- (void)touchUpOutsideBtnRecord:(id)sender {
    NSLog(@"touchUpOutsideBtnRecord");
    [self.noiseRecorder stop];
    self.recordLabel.text = @"按住测量";
}

- (void)touchUpInsideBtnRecord:(id)sender {
    NSLog(@"touchUpInsideBtnRecord");
    [self.noiseRecorder stop];
    self.recordLabel.text = @"按住测量";
}

- (void)dragExitBtnRecord:(id)sender {
    NSLog(@"dragExitBtnRecord");
    [self showRevokeRecordingView];
    self.recordLabel.text = @"松开手指，取消测量";
}

- (void)dragEnterBtnRecord:(id)sender {
    NSLog(@"dragEnterBtnRecord");
    [self showRecordingView];
    self.recordLabel.text = @"松开结束";
}


#pragma mark - NCPNoiseRecorderDelegate

- (void)willStartRecording {

}

- (void)didUpdateAveragePower:(NCPPower)averagePoer PeakPower:(NCPPower)peakPower {

}

- (void)didStopRecording {
    [self dismisRecordingView];
}

#pragma mark - 控制界面

- (void)showRecordingView {
    if (self.recordingAlertView) {
        return;
    }
    [self.recordingRevokeView removeFromSuperview];
    self.recordingRevokeView = nil;
    self.recordingAlertView = [self showAlertView];

    UIImageView *recordingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record"]];
    recordingImageView.center = CGPointMake(self.recordingAlertView.frame.size.width / 2, self.recordingAlertView.frame.size.height / 2);
    [self.recordingAlertView addSubview:recordingImageView];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"正在测量...";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.layer.anchorPoint = CGPointMake(0.5, 0.5);
    label.center = CGPointMake(self.recordingAlertView.frame.size.width / 2, self.recordingAlertView.frame.size.height - 30);
    [self.recordingAlertView addSubview:label];
}

- (void)showRevokeRecordingView {
    if (self.recordingRevokeView) {
        return;
    }
    [self.recordingAlertView removeFromSuperview];
    self.recordingAlertView = nil;
    self.recordingRevokeView = [self showAlertView];

    UIImageView *revokeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"revokeRecord"]];
    revokeImageView.center = CGPointMake(self.recordingRevokeView.frame.size.width / 2, self.recordingRevokeView.frame.size.height / 2);
    [self.recordingRevokeView addSubview:revokeImageView];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"松开手指，取消测量";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    label.alpha = 0.5;
    [label sizeToFit];
    label.layer.anchorPoint = CGPointMake(0.5, 0.5);
    label.center = CGPointMake(self.recordingRevokeView.frame.size.width / 2, self.recordingRevokeView.frame.size.height - 30);
    [self.recordingRevokeView addSubview:label];
}

- (UIView *)showAlertView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.width / 2);
    view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    view.tag = 100;
    [self.view addSubview:view];
    return view;
}

- (void)dismisRecordingView {
    [[self.view.window viewWithTag:100] removeFromSuperview];
    self.recordingRevokeView = nil;
    self.recordingAlertView = nil;
}


@end
