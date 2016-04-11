//
//  NCPMeterView.m
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPMeterView.h"

#pragma mark - 获取配置常量

// 获取字体大小
static double fontSize() {
    static double size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = NCPConfigDouble(@"MeterViewFontSize");
    });
    return size;
}

// 获取不同字数下的字体大小比例
static double fontRatio(NSUInteger i) {
    static NSArray *ratios;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratios = NCPConfigArray(@"MeterViewFontRatios");
    });
    return ((NSNumber *) ratios[i]).doubleValue;
}

// 获取最大值
static double max() {
    static double max;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        max = NCPConfigDouble(@"MeterViewMaxValue");
    });
    return max;
}

// 获取最小值
static double min() {
    static double min;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        min = NCPConfigDouble(@"MeterViewMinValue");
    });
    return min;
}

@interface NCPMeterView ()

#pragma mark - Xib输出口

@property(weak, nonatomic) IBOutlet UIImageView *imageForeground;
@property(weak, nonatomic) IBOutlet UILabel *labelValue;
@property(weak, nonatomic) IBOutlet UIImageView *imageCursor;

@end

@implementation NCPMeterView

// 布局子视图
- (void)layoutSubviews {
    // 设置初始值
    [self setValueWithLable:(max() + min()) / 2];
    [super layoutSubviews];
}

#pragma mark - 设置当前值方法

// 当前数值, 修改时只会影响周围的进度条不会影响中间数字
- (void)setValue:(double)value {
    // 限制输入值大小
    _value = value <= min() ? min() : value >= max() ? max() : value;

    // 刷新自身
    [self setNeedsDisplay];
}

// 连数字一同设置值
- (void)setValueWithLable:(double)value {
    // 限制输入值大小
    _value = value <= min() ? min() : value >= max() ? max() : value;

    // 计算字体
    CGRect rect = self.bounds;
    double ratio = fontSize();
    NSString *valueStr = [NSString stringWithFormat:@"%.0f", _value];
    if (valueStr.length > 0 && valueStr.length <= 4) {
        ratio *= fontRatio(valueStr.length - 1);
    }
    self.labelValue.font = [UIFont fontWithName:@"Arial-BoldMT" size:(CGFloat) (rect.size.width * ratio)];
    self.labelValue.text = valueStr;

    // 刷新自身
    [self setNeedsDisplay];
}

#pragma mark - 绘制方法

// 绘制方法
- (void)drawRect:(CGRect)rect {

    // Drawing code
    CGFloat centerX = rect.size.width / 2.0f + rect.origin.x;
    CGFloat centerY = rect.size.height / 2.0f + rect.origin.y;
    CGFloat radius = rect.size.width / 2.0f;
    const CGFloat zeroAngle = (const CGFloat) M_PI_4 * 3;
    CGFloat endAngle = (CGFloat) ((self.value - min()) * M_PI * 1.5 / (max() - min()) + zeroAngle);

    // 创建遮罩图层
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = self.bounds;

    // 绘制Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, centerX, centerY);
    CGPathAddArc(path, &CGAffineTransformIdentity, centerX, centerY, radius, zeroAngle, endAngle, 0);
    mask.path = path;

    // 将遮罩图层加入imageLight
    self.imageForeground.layer.mask = mask;

    // 旋转光标
    self.imageCursor.transform = CGAffineTransformMakeRotation((CGFloat) (endAngle - 3 * M_PI_4));
}

@end


