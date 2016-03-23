//
//  NCPMeterView.m
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPMeterView.h"

#pragma mark - 常量定义

static const float kValueMax = 120;
static const float kValueMin = 0;

static const float kFontRatio = 0.546f;
static const float kFontLengthRatio[4] = {1.0f, 0.833f, 0.708f, 0.602f};

@interface NCPMeterView ()

#pragma mark - Xib输出口

@property(weak, nonatomic) IBOutlet UIView *referencedView;
@property(weak, nonatomic) IBOutlet UIImageView *imageLight;
@property(weak, nonatomic) IBOutlet UILabel *labelValue;

@end

@implementation NCPMeterView

#pragma mark - 初始化与布局

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"NCPMeterView" owner:self options:nil];
        [self addSubview:self.referencedView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.referencedView.frame = self.bounds;
    [self setValueWithLable:kValueMin];
}

#pragma mark - 设置当前值

- (void)setValue:(float)value {
    // 限制输入值大小
    _value = value <= kValueMin ? kValueMin : value >= kValueMax ? kValueMax : value;

    // 刷新自身
    [self setNeedsDisplay];
}

- (void)setValueWithLable:(float)value {
    // 限制输入值大小
    _value = value <= kValueMin ? kValueMin : value >= kValueMax ? kValueMax : value;

    // 计算字体
    CGRect rect = self.bounds;
    float ratio = kFontRatio;
    NSString *valueStr = [NSString stringWithFormat:@"%.0f", _value];
    if (valueStr.length > 0 && valueStr.length <= 4) {
        ratio *= kFontLengthRatio[valueStr.length - 1];
    }
    self.labelValue.font = [UIFont fontWithName:@"Arial-BoldMT" size:rect.size.width * ratio];
    self.labelValue.text = valueStr;

    // 刷新自身
    [self setNeedsDisplay];
}

#pragma mark - 绘制方法

- (void)drawRect:(CGRect)rect {

    // Drawing code
    CGFloat centerX = rect.size.width / 2.0f + rect.origin.x;
    CGFloat centerY = rect.size.height / 2.0f + rect.origin.y;
    CGFloat radius = rect.size.width / 2.0f;
    const CGFloat zeroAngle = (const CGFloat) M_PI_2;
    CGFloat endAngle = (CGFloat) ((self.value - kValueMin) * M_PI * 2 / (kValueMax - kValueMin) + zeroAngle);

    // 创建遮罩图层
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = self.bounds;

    // 绘制Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, centerX, centerY);
    CGPathAddArc(path, &CGAffineTransformIdentity, centerX, centerY, radius, zeroAngle, endAngle, 0);
    mask.path = path;

    // 将遮罩图层加入imageLight
    self.imageLight.layer.mask = mask;
}
@end
