//
//  NCPMeterViewController.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPMeterViewController.h"
#import "NCPNoiseMeter.h"

@interface NCPMeterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;

@property (weak, nonatomic) IBOutlet UILabel *lableSPL;

@property (weak, nonatomic) IBOutlet NCPGraphView *graphView;

@end

@implementation NCPMeterViewController

/** (重写)viewDidLoad方法 */
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // 实例化噪声仪对象
    NCPNoiseMeter *meter = [[NCPNoiseMeter alloc] init];
    
    [meter startWithCallback:^{
        CGFloat halfWidth = _imageViewArrow.layer.bounds.size.height/2;
        
        CGAffineTransform transform =CGAffineTransformMakeTranslation(0, halfWidth);
        transform = CGAffineTransformRotate(transform, (meter.lastAvg+100)/180*3.14);
        transform = CGAffineTransformTranslate(transform,-0,-halfWidth);
        _imageViewArrow.transform = transform;
        
        _lableSPL.text = [NSString stringWithFormat:@"%d", (int)(100+meter.lastAvg)];
        
        [_graphView addValue:100+meter.lastAvg];
        
    }];
}

@end
