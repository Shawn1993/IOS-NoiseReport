//
//  NCPGraoh.m
//  NoiseComplain
//
//  Created by cheikh on 2/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPGraphView.h"

@interface NCPGraphView()

// 坐标轴的上下限
@property int maxY;
@property int minY;
@property int maxX;
@property int minX;

@end


@implementation NCPGraphView

// 坐标点集合
NSMutableArray<NSNumber*> *points;

// 显示的点的开始索引
int displayIndex;

- (void)initData{
    points = [[NSMutableArray alloc] init];
    displayIndex = 0;
    _maxY = 110;
    _minY = 0;
    _maxX = 200;
    _minX = 0;
}

#pragma mark - 重写方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
}

// 绘制图像
- (void)drawRect:(CGRect)rect
{
    int pointCount = (int)[points count];
    float ySpace = self.frame.size.height/(_maxY-_minY);
    float xSpace = self.frame.size.width/(_maxX-_minX);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context,5.0);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0, 1.0);
    
    //开始绘制曲线
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0,self.frame.size.height-[[points objectAtIndex:pointCount-1] doubleValue]*ySpace);
    
    int displayCount = pointCount>(_maxX-_minX)?(_maxX-_minX):pointCount;
    //    int curveCount = (displayCount-1)/3;
    //
    //    // 首先绘制三次贝赛尔曲线
    //    int x=0;
    //    int i=0;
    //    for(; i <curveCount ; i++)
    //    {
    //        double x0 = (++x)*xSpace;
    //        double x1 = (++x)*xSpace;
    //        double x2 = (++x)*xSpace;
    //        double value0 = self.frame.size.height-[[points objectAtIndex:pointCount-i*3-1] doubleValue]*ySpace;
    //        double value1 = self.frame.size.height-[[points objectAtIndex:pointCount-i*3-2] doubleValue]*ySpace;
    //        double value2 = self.frame.size.height-[[points objectAtIndex:pointCount-i*3-3] doubleValue]*ySpace;
    //
    //        CGContextAddCurveToPoint(context, x0, value0, x1 ,value1, x2, value2);
    //    }
    for(int i =1; i<displayCount;i++)
    {
        double y = self.frame.size.height-[[points objectAtIndex:pointCount-i-1] doubleValue]*ySpace;
        double x = i*xSpace;
        CGContextAddLineToPoint(context,x,y);
    }
    CGContextStrokePath(context);
}

#pragma mark - 暴露的方法
-(void)addValue:(float)value{
    if(points){
        [points addObject:[NSNumber numberWithDouble:value]];
    }
    [self setNeedsDisplay];
}

@end
