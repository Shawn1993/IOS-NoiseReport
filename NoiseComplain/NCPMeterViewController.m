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

@interface NCPMeterViewController ()<NCPNoiseRecorderDelegate>
{
    NSTimer *mTimer;
    NCPNoiseMeter *mNoiseMeter;
    double mValueSPL;
}
@property (weak, nonatomic) IBOutlet NCPDashboardView *dashboardView;

@property (weak, nonatomic) IBOutlet UILabel *labelSPL;

@property (weak, nonatomic) IBOutlet NCPGraphView *graphView;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (nonatomic) NCPNoiseRecorder *noiseRecorder;

@end

@implementation NCPMeterViewController

#pragma mark - 生命周期

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad{

    [super viewDidLoad];
    [self initView];
    
    self.noiseRecorder = [[NCPNoiseRecorder alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [self initNoiseMeter];
    self.noiseRecorder.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.noiseRecorder.delegate = nil;
    
    if(mNoiseMeter){
        [mNoiseMeter stop];
        mNoiseMeter = nil;
    }
}

#pragma mark - 初始化方法

- (void)initView{
    [self.btnRecord addTarget:self action:@selector(touchDownBtnRecord:) forControlEvents:UIControlEventTouchDown];
    [self.btnRecord addTarget:self action:@selector(touchUpInsideBtnRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord addTarget:self action:@selector(touchUpOutsideBtnRecord:) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnRecord addTarget:self action:@selector(dragOutsideBtnRecord:) forControlEvents:UIControlEventTouchDragExit];
}


-(void)initNoiseMeter{

    mNoiseMeter = [[NCPNoiseMeter alloc] init];
    
    [mNoiseMeter startWithCallback:^{
        
        mValueSPL = mNoiseMeter.lastAvg+120;
 
        self.labelSPL.text = [NSString stringWithFormat:@"%d", (int)(mValueSPL)];
        
        [self.graphView addValue:mValueSPL];
        
        [self.dashboardView showValue:mValueSPL];
    }];
}


#pragma mark - btnRecord Action
-(void)touchDownBtnRecord:(id)sender{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.width/2);
    view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);

    view.tag = 100;
    view.layer.masksToBounds =YES;
    view.layer.cornerRadius = 10;
    [self.view addSubview:view];
    
    UIImageView *recordingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record"]];
    recordingImageView.center = CGPointMake(view.frame.size.width/4, view.frame.size.height/2);
    [view addSubview:recordingImageView];
    
    [self.noiseRecorder start];
    
}

-(void)touchUpOutsideBtnRecord:(id)sender{
    [[self.view.window viewWithTag:100] removeFromSuperview];
    [self.noiseRecorder stop];
}

-(void)touchUpInsideBtnRecord:(id)sender{
    [[self.view.window viewWithTag:100] removeFromSuperview];
    [self.noiseRecorder stop];
}

-(void)dragOutsideBtnRecord:(id)sender{
    
}

#pragma mark - NCPNoiseRecorderDelegate
- (void)willStartRecording{
    
}

- (void)didUpdateAveragePower:(NCPPower)averagePoer PeakPower:(NCPPower)peakPower{
    
    
}

- (void)didStopRecording{
    
}


@end
