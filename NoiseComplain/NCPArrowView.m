//
//  NCPArrowView.m
//  NoiseComplain
//
//  Created by cheikh on 20/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPArrowView.h"
#define SIZE_W (self.frame.size.width)
#define SIZE_H (self.frame.size.height)
#define SIZE_W_2 SIZE_W/2
#define SIZE_H_2 SIZE_H/2

@implementation NCPArrowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawArrow:context Rect:rect];
}


- (void) drawArrow:(CGContextRef) context Rect:(CGRect) rect{
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.size.width/2, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width/2, 0);
    
    CGContextMoveToPoint(context, 0, rect.size.width/2);
    CGContextAddLineToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.width/2);
    CGContextStrokePath(context);
}

@end
