//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseMeter.h"
#import "NCPDashboardView.h"
#import "NCPArrowView.h"

// 屏幕大小
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)


#define ARROW_LENGTH 140
#define ARROW_WIDTH 10

@interface NCPMeterViewController (){
    NSTimer *mTimer;
    NCPNoiseMeter *mNoiseMeter;
    double mValueSPL;
}
@property (weak, nonatomic) IBOutlet NCPDashboardView *dashboardView;

@property (weak, nonatomic) IBOutlet UILabel *lableSPL;

@property (weak, nonatomic) IBOutlet NCPGraphView *graphView;

@property (strong, nonatomic) NCPArrowView *arrowView;

@end

@implementation NCPMeterViewController

#pragma mark - 生命周期

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad{

    [super viewDidLoad];
    [self initView];
    [self initNoiseMeter];
    
}

#pragma mark - 初始化方法

- (void)initView{
    // 背景颜色
    _graphView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
}

-(void)initNoiseMeter{

    mNoiseMeter = [[NCPNoiseMeter alloc] init];
    
    [mNoiseMeter startWithCallback:^{
        
        mValueSPL = mNoiseMeter.lastAvg+120;
 
        self.lableSPL.text = [NSString stringWithFormat:@"%d", (int)(mValueSPL)];
        
        [self.graphView addValue:mValueSPL];
        
        [self.dashboardView showValue:mValueSPL];
    }];
}



@end
