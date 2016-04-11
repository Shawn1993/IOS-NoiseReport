//
//  NCPGraphView.m
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPGraphView.h"

#pragma mark - 获取配置信息

// 获取最大值
static double max() {
    static double max;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        max = NCPConfigDouble(@"GraphViewMaxValue");
    });
    return max;
}

// 获取最小值
static double min() {
    static double min;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        min = NCPConfigDouble(@"GraphViewMinValue");
    });
    return min;
}

// 获取值最大数量
static NSUInteger capacity() {
    static NSUInteger capacity;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        capacity = NCPConfigUnsignedInteger(@"GraphViewCapacity");
    });
    return capacity;
}

// 获取网格列数
static NSUInteger gridColumn() {
    static NSUInteger column;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        column = NCPConfigUnsignedInteger(@"GraphViewGridColumn");
    });
    return column;
}

// 获取网格行数
static NSUInteger gridRow() {
    static NSUInteger row;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        row = NCPConfigUnsignedInteger(@"GraphViewGridRow");
    });
    return row;
}

// 获取网格显示最大值
static double gridMax() {
    static double max;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        max = NCPConfigDouble(@"GraphViewGridMaxValue");
    });
    return max;
}

// 获取网格显示最小值
static double gridMin() {
    static double min;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        min = NCPConfigDouble(@"GraphViewGridMinValue");
    });
    return min;
}

#pragma maek - 计算纵坐标

// 计算纵坐标
static CGFloat calY(CGRect rect, double value) {
    return (CGFloat) (rect.size.height - rect.size.height * (value - min()) / (max() - min()));
};

@interface NCPGraphView ()

#pragma mark - Storyboard输出口

@property(weak, nonatomic) IBOutlet UIImageView *imageDot;
@property(weak, nonatomic) IBOutlet UIImageView *imageLine;
@property(weak, nonatomic) IBOutlet UILabel *labelAverage;

#pragma mark - 数值获取
@property(nonatomic, readonly) NSMutableArray *values;
@property(nonatomic, readonly) double last;
@property(nonatomic) double average;
@property(nonatomic) unsigned long offset;

@end

@implementation NCPGraphView

#pragma mark - 初始化与布局

// 初始化方法
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // 初始化数组, 并赋予初值
        _values = [NSMutableArray arrayWithCapacity:capacity()];
        [_values addObject:@((max() + min()) / 2)];
        self.offset = 1;
    }
    return self;
}

#pragma mark - 设置与获取值

// 添加一个值
- (void)addValue:(double)value {

    // 限制输入值大小
    value = value <= min() ? min() : value >= max() ? max() : value;

    // 添加值
    if (self.values.count >= capacity()) {
        [self.values removeObjectAtIndex:0];
    }
    [self.values addObject:@(value)];

    // 计算平均值
    double sum = 0.0;
    for (NSNumber *v in self.values) {
        sum += v.doubleValue;
    }
    self.average = sum / self.values.count;

    // 设置平均值提示
    self.labelAverage.text = [NSString stringWithFormat:@"平均: %.0fdB", self.average];

    // 刷新自身
    self.offset++;
    [self setNeedsDisplay];
}

// 获取最新值
- (double)last {
    return ((NSNumber *) self.values.lastObject).doubleValue;
}

#pragma mark - 绘制方法


// 绘制方法
- (void)drawRect:(CGRect)rect {

    // 计算控件大小
    CGFloat dotThick = self.imageDot.frame.size.height / 2;
    CGFloat lineThick = self.imageLine.frame.size.height / 2;

    // 设置点位置
    CGFloat dotY = calY(rect, self.last);
    CGRect dotFrame = self.imageDot.frame;
    dotFrame.origin.y = dotY - dotThick;
    self.imageDot.frame = dotFrame;

    // 设置平均线
    CGFloat lineY = calY(rect, self.average);
    CGRect lineFrame = self.imageLine.frame;
    lineFrame.origin.y = lineY - lineThick;
    self.imageLine.frame = lineFrame;

    // 计算坐标
    CGFloat start = self.imageDot.frame.origin.x + dotThick;
    CGFloat end = rect.origin.x + rect.size.width - dotThick;
    CGFloat step = (end - start) / (capacity() - 3);

    // 绘制轨迹线
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    CGMutablePathRef ph1 = CGPathCreateMutable();
    CGFloat x = start;
    NSUInteger index = self.values.count - 1;
    while (index >= 3) {
        double vm1 = ((NSNumber *) self.values[index]).doubleValue;
        double v0 = ((NSNumber *) self.values[index - 1]).doubleValue;
        double v1 = ((NSNumber *) self.values[index - 2]).doubleValue;
        double v2 = ((NSNumber *) self.values[index - 3]).doubleValue;
        double c0 = v0 + (v1 - vm1) / 4;
        double c1 = v1 - (v2 - v0) / 4;
        CGContextMoveToPoint(ctx1, x, calY(rect, v0));
        CGContextAddCurveToPoint(ctx1,
                x + step / 2, calY(rect, c0),
                x + step / 2, calY(rect, c1),
                x + step, calY(rect, v1));
        x += step;
        index--;
    }
    CGContextAddPath(ctx1, ph1);
    CGContextSetLineWidth(ctx1, 6);
    CGContextSetRGBStrokeColor(ctx1, 0.7412, 0.7176, 0.8980, 0.65);
    CGContextStrokePath(ctx1);

    // 绘制网格
    CGFloat left = rect.origin.x + 8;
    CGFloat right = left + rect.size.width - 16;
    CGFloat top = rect.origin.y + 8;
    CGFloat bottom = top + rect.size.height - 16;
    CGContextRef ctx3 = UIGraphicsGetCurrentContext();
    CGMutablePathRef ph3 = CGPathCreateMutable();
    NSUInteger gridColumnStep = capacity() / gridColumn();
    for (long j = self.offset % gridColumnStep; j <= capacity(); j += gridColumnStep) {
        CGPathMoveToPoint(ph3, NULL, left + j * step, top);
        CGPathAddLineToPoint(ph3, NULL, left + j * step, bottom);
    }
    if (gridRow() > 2) {
        double gridRowStep = (gridMax() - gridMin()) / gridRow();
        for (double k = gridMin(); k <= gridMax(); k += gridRowStep) {
            CGPathMoveToPoint(ph3, NULL, left, calY(rect, k));
            CGPathAddLineToPoint(ph3, NULL, right, calY(rect, k));
        }
    }
    CGContextAddPath(ctx3, ph3);
    CGContextSetLineWidth(ctx3, 1);
    CGContextSetCMYKStrokeColor(ctx3, 0.7, 0.67, 0.29, 0.1, 0.2);
    CGContextStrokePath(ctx3);

    CGPathRelease(ph1);
    // CGPathRelease(ph2);
    CGPathRelease(ph3);
}

@end
