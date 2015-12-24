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

@property (weak, nonatomic) IBOutlet UILabel *labelSPL;

@property (weak, nonatomic) IBOutlet NCPGraphView *graphView;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;


@end

@implementation NCPMeterViewController

#pragma mark - 生命周期

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad{

    [super viewDidLoad];
    [self initView];
    [self initNoiseMeter];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark - 初始化方法

- (void)initView{
    [self.btnRecord addTarget:self action:@selector(touchDownBtnRecord:) forControlEvents:UIControlEventTouchDown];
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
    
    self.navigationController.navigationBar.translucent = YES;
 
    UIView *view = [[UIView alloc] initWithFrame:self.view.window.frame];
    NSLog(@"%f %f",self.view.window.frame.size.width,self.view.window.frame.size.height);
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
}

-(void)dragOutsideBtnRecord:(id)sender{
    NSLog(@"outside");
}

-(void)touchUpOutsideBtnRecord:(id)sender{
    
}

@end
