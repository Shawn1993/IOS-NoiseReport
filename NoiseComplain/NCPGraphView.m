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
        capacity = (NSUInteger) NCPConfigInteger(@"GraphViewCapacity");
    });
    return capacity;
}

// 获取网格列数
static NSUInteger gridColumn() {
    static NSUInteger column;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        column = (NSUInteger) NCPConfigInteger(@"GraphViewGridColumn");
    });
    return column;
}

// 获取网格行数
static NSUInteger gridRow() {
    static NSUInteger row;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        row = (NSUInteger) NCPConfigInteger(@"GraphViewGridRow");
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

#pragma mark - Xib输出口

@property(weak, nonatomic) IBOutlet UIView *referencedView;
@property(weak, nonatomic) IBOutlet UIImageView *imageDot;
@property(weak, nonatomic) IBOutlet UIImageView *imageLine;
@property(weak, nonatomic) IBOutlet UILabel *labelAverage;

#pragma mark - 数值获取
@property(nonatomic, readonly) NSMutableArray *values;
@property(nonatomic, readonly) double last;
@property(nonatomic) double average;
@property(nonatomic) int offset;

@end

@implementation NCPGraphView

#pragma mark - 初始化与布局

// 初始化方法
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // 初始化数组, 并赋予初值
        _values = [NSMutableArray arrayWithCapacity:(NSUInteger) NCPConfigInteger(@"GraphViewCapacity")];
        [_values addObject:@((max() + min()) / 2)];
        self.offset = 1;

        // 读取Xib
        [[NSBundle mainBundle] loadNibNamed:@"NCPGraphView" owner:self options:nil];
        [self addSubview:self.referencedView];
    }
    return self;
}

// 布局子视图
- (void)layoutSubviews {
    self.referencedView.frame = self.bounds;
    [super layoutSubviews];
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
    for (NSNumber *value in self.values) {
        sum += value.doubleValue;
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
    CGFloat step = (end - start) / capacity();
    CGFloat x = start;

    // 绘制轨迹线
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGMutablePathRef p = CGPathCreateMutable();
    CGPathMoveToPoint(p, NULL, start, dotY);
    for (int i = (int) self.values.count - 1; i >= 0; i--) {
        x += step;
        CGFloat y = calY(rect, ((NSNumber *) self.values[(NSUInteger) i]).doubleValue);
        CGPathAddLineToPoint(p, NULL, x, y);
    }
    CGContextAddPath(c, p);
    CGContextSetLineWidth(c, 4.5);
    CGContextSetRGBStrokeColor(c, 0.7412, 0.7176, 0.8980, 0.7);
    CGContextStrokePath(c);

    // 绘制模糊发光
    CGContextRef c2 = UIGraphicsGetCurrentContext();
    CGPathRef p2 = CGPathCreateCopy(p);
    CGContextAddPath(c2, p2);
    CGContextSetLineWidth(c2, 7);
    CGContextSetRGBStrokeColor(c2, 0.7412, 0.7176, 0.8980, 0.09);
    CGContextStrokePath(c2);

    // 绘制边框
    CGFloat left = rect.origin.x + 8;
    CGFloat right = left + rect.size.width - 16;
    CGFloat top = rect.origin.y + 8;
    CGFloat bottom = top + rect.size.height - 16;
    CGContextRef c3 = UIGraphicsGetCurrentContext();
    CGMutablePathRef p3 = CGPathCreateMutable();
    int gridColumnStep = (int) (capacity() / gridColumn());
    for (int j = self.offset % gridColumnStep; j <= capacity(); j += gridColumnStep) {
        CGPathMoveToPoint(p3, NULL, left + j * step, top);
        CGPathAddLineToPoint(p3, NULL, left + j * step, bottom);
    }
    if (gridRow() > 2) {
        double gridRowStep = (gridMax() - gridMin()) / gridRow();
        for (double k = gridMin(); k <= gridMax(); k += gridRowStep) {
            CGPathMoveToPoint(p3, NULL, left, calY(rect, k));
            CGPathAddLineToPoint(p3, NULL, right, calY(rect, k));
        }
    }
    CGContextAddPath(c3, p3);
    CGContextSetLineWidth(c3, 1);
    CGContextSetCMYKStrokeColor(c3, 0.7, 0.67, 0.29, 0.1, 0.2);
    CGContextStrokePath(c3);

    CGPathRelease(p);
    CGPathRelease(p2);
    CGPathRelease(p3);
}

@end
