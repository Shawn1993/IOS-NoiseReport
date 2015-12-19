//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseMeter.h"

// 屏幕大小
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEGREE_TO_RADIAN(x) ((x)*M_PI/180)
#define RADIAN_TO_DEGREE(x) ((x)/M_PI*180)

@interface NCPMeterViewController (){
    NSTimer *mTimer;
    NCPNoiseMeter *mNoiseMeter;
    double mValueSPL;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;

@property (weak, nonatomic) IBOutlet UILabel *lableSPL;

@property (weak, nonatomic) IBOutlet NCPGraphView *graphView;

@end

@implementation NCPMeterViewController

#pragma mark - 生命周期

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad{

    [super viewDidLoad];
    [self initView];
    [self initNoiseMeter];
    [self initTimer];
}

#pragma mark - 初始化方法

- (void)initView{
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _graphView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

-(void)initNoiseMeter{

    mNoiseMeter = [[NCPNoiseMeter alloc] init];
    
    [mNoiseMeter startWithCallback:^{
        
        mValueSPL = 100+mNoiseMeter.lastAvg;
        _lableSPL.text = [NSString stringWithFormat:@"%d", (int)(mValueSPL)];
        [self rotateArrow:mValueSPL];
         [_graphView addValue:mValueSPL];
    }];
}


-(void)initTimer
{
//    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [mTimer fire];
}

#pragma mark - 控制界面

/** 旋转仪表盘箭头: 角度 */
- (void) rotateArrow:(double) degree{
    CGFloat halfHeight= _imageViewArrow.layer.bounds.size.height/2;
    CGAffineTransform transform;
    
    transform = CGAffineTransformMakeTranslation(0, halfHeight);
    transform = CGAffineTransformRotate(transform, DEGREE_TO_RADIAN(degree));
    transform = CGAffineTransformTranslate(transform, 0,-halfHeight);
    
    _imageViewArrow.transform = transform;
}

@end
