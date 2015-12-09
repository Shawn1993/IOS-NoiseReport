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

@interface NCPMeterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;

@property (weak, nonatomic) IBOutlet UILabel *lableSPL;

@property (weak, nonatomic) IBOutlet NCPGraphView *graphView;

@end

@implementation NCPMeterViewController

NSTimer *mTimer;
double valueSPL;

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad {
    
    [super viewDidLoad];

   
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    // 实例化噪声仪对象
    NCPNoiseMeter *meter = [[NCPNoiseMeter alloc] init];
    
    [meter startWithCallback:^{
        valueSPL = 100+meter.lastAvg;
//        [self rotateArrow:valueSPL];
    }];
    
    [mTimer fire];
}

/** 旋转仪表盘箭头: 角度 */
- (void) rotateArrow:(double) degree{
    CGFloat halfHeight= _imageViewArrow.layer.bounds.size.height/2;
    CGAffineTransform transform;
    
    transform = CGAffineTransformMakeTranslation(0, halfHeight);
    transform = CGAffineTransformRotate(transform, DEGREE_TO_RADIAN(degree));
    transform = CGAffineTransformTranslate(transform, 0,-halfHeight);
    
    _imageViewArrow.transform = transform;
}

-(void) rotateArrowWithAnimation:(double) degree{
    CGFloat halfHeight= _imageViewArrow.layer.bounds.size.height/2;
    CGAffineTransform transform;
    
    transform = CGAffineTransformMakeTranslation(0, halfHeight);
    transform = CGAffineTransformRotate(transform, DEGREE_TO_RADIAN(degree));
    transform = CGAffineTransformTranslate(transform, 0,-halfHeight);

    [UIView beginAnimations:nil context:NULL];
    [_imageViewArrow.layer setAffineTransform:transform];
    _imageViewArrow.layer.opacity = 1;
    [UIView commitAnimations];

}

/** 定时器调用的执行方法*/
- (void) timerAction{
    [self rotateArrowWithAnimation:valueSPL];
    _lableSPL.text = [NSString stringWithFormat:@"%d", (int)(valueSPL)];
    [_graphView addValue:valueSPL];
}

@end
