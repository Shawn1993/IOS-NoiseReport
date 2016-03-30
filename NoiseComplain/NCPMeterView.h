//
//  NCPMeterView.h
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 噪声强度仪表盘View
 */
@interface NCPMeterView : UIView

// 当前数值, 修改时只会影响周围的进度条不会影响中间数字
@property(nonatomic, assign, setter=setValue:) double value;

// 连数字一同设置值
- (void)setValueWithLable:(double)value;

@end
