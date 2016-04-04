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
static int capacity() {
    static int capacity;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        capacity = NCPConfigInteger(@"GraphViewCapacity");
    });
    return capacity;
}

// 获取网格列数
static int gridColumn() {
    static int column;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        column = NCPConfigInteger(@"GraphViewGridColumn");
    });
    return column;
}

// 获取网格行数
static int gridRow() {
    static int row;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        row = NCPConfigInteger(@"GraphViewGridRow");
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

// 获取平滑系数
static int smooth() {
    static int dilute;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dilute = NCPConfigInteger(@"GraphViewSmooth");
    });
    return dilute;
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
@property(nonatomic) unsigned long offset;

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
    CGFloat step = (end - start) / (capacity() - smooth());

    // 绘制轨迹线
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    CGMutablePathRef ph1 = CGPathCreateMutable();
    CGFloat x = start;
    CGPathMoveToPoint(ph1, NULL, start, dotY);
    int index = (int) (self.values.count - 1);
    for (int i = 0; i < self.offset % smooth(); i++) {
        CGPathAddLineToPoint(ph1, NULL, x, calY(rect, ((NSNumber *) self.values[(NSUInteger) index]).doubleValue));
        x += step;
        index--;
    }
    if (index >= 0) {
        CGPathAddLineToPoint(ph1, NULL, x, calY(rect, ((NSNumber *) self.values[(NSUInteger) index]).doubleValue));
    }
    while (index >= 3 * smooth()) {
        double vm1 = ((NSNumber *) self.values[(NSUInteger) index]).doubleValue;
        double v0 = ((NSNumber *) self.values[(NSUInteger) (index - smooth())]).doubleValue;
        double v1 = ((NSNumber *) self.values[(NSUInteger) (index - 2 * smooth())]).doubleValue;
        double v2 = ((NSNumber *) self.values[(NSUInteger) (index - 3 * smooth())]).doubleValue;
        double k0 = (v1 - vm1) / 2;
        double k1 = (v2 - v0) / 2;
        CGPoint p0 = CGPointMake(x, calY(rect, v0));
        CGPoint c0 = CGPointMake(x + step * smooth() / 2, calY(rect, v0 + k0 / 2));
        CGPoint c1 = CGPointMake(x + step * smooth() / 2, calY(rect, v1 - k1 / 2));
        CGPoint p1 = CGPointMake(x + step * smooth(), calY(rect, v1));
        CGContextMoveToPoint(ctx1, p0.x, p0.y);
        CGContextAddCurveToPoint(ctx1, c0.x, c0.y, c1.x, c1.y, p1.x, p1.y);
        x += step * smooth();
        index -= smooth();
    }
    CGContextAddPath(ctx1, ph1);
    CGContextSetLineWidth(ctx1, 6);
    CGContextSetRGBStrokeColor(ctx1, 0.7412, 0.7176, 0.8980, 0.65);
    CGContextStrokePath(ctx1);

    // 绘制模糊发光
    /*CGContextRef ctx2 = UIGraphicsGetCurrentContext();
    CGPathRef ph2 = CGPathCreateCopy(ph1);
    CGContextAddPath(ctx2, ph2);
    CGContextSetLineWidth(ctx2, 9);
    CGContextSetRGBStrokeColor(ctx2, 0.7412, 0.7176, 0.8980, 0.5);
    CGContextStrokePath(ctx2);*/

    // 绘制网格
    CGFloat left = rect.origin.x + 8;
    CGFloat right = left + rect.size.width - 16;
    CGFloat top = rect.origin.y + 8;
    CGFloat bottom = top + rect.size.height - 16;
    CGContextRef ctx3 = UIGraphicsGetCurrentContext();
    CGMutablePathRef ph3 = CGPathCreateMutable();
    int gridColumnStep = capacity() / gridColumn();
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
