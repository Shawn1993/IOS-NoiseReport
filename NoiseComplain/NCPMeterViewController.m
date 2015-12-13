//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseMeter.h"
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

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad{
    [super viewDidLoad];
//    [self prefersStatusBarHidden];
    
    [self initNoiseMeter];
    [self initTimer];
}

#pragma mark - 初始化方法

-(void)initNoiseMeter{

    mNoiseMeter = [[NCPNoiseMeter alloc] init];
    
    [mNoiseMeter startWithCallback:^{
        
        mValueSPL = 100+mNoiseMeter.lastAvg;
        NSLog(@"%d",(int)mValueSPL);
        
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
//
//-(void) rotateArrowWithAnimation:(double) degree{
//    CGFloat halfHeight= _imageViewArrow.layer.bounds.size.height/2;
//    CGAffineTransform transform;
//    
//    transform = CGAffineTransformMakeTranslation(0, halfHeight);
//    transform = CGAffineTransformRotate(transform, DEGREE_TO_RADIAN(degree));
//    transform = CGAffineTransformTranslate(transform, 0,-halfHeight);
//
//    [UIView beginAnimations:nil context:NULL];
//    [_imageViewArrow.layer setAffineTransform:transform];
//    _imageViewArrow.layer.opacity = 1;
//    [UIView commitAnimations];
//
//}
//
///** 定时器调用的执行方法*/
//- (void) timerAction{
//    [self rotateArrowWithAnimation:mValueSPL];
//    _lableSPL.text = [NSString stringWithFormat:@"%d", (int)(mValueSPL)];
//    [_graphView addValue:mValueSPL];
//}

@end
