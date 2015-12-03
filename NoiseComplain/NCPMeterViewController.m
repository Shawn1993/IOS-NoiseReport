//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseMeter.h"
#define DEGREE_TO_RADIAN(x) ((x)*3.14/180)
#define RADIAN_TO_DEGREE(x) ((x)/3.14*180)

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
        [self rotateArrow:valueSPL];
    }];
    
    [mTimer fire];
}

- (void) rotateArrow:(double) degree{
    CGFloat halfHeight = _imageViewArrow.layer.bounds.size.height/2;
    
    CGAffineTransform transform =CGAffineTransformMakeTranslation(0, halfHeight);
    transform = CGAffineTransformRotate(transform, DEGREE_TO_RADIAN(degree));
    transform = CGAffineTransformTranslate(transform,-0,-halfHeight);
    _imageViewArrow.transform = transform;

}

- (void) timerAction{
  
    
    _lableSPL.text = [NSString stringWithFormat:@"%d", (int)(valueSPL)];
    
    [_graphView addValue:valueSPL];

}

@end
