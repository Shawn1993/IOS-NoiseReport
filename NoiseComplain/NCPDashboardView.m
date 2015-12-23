//
//  NCPDashboardView.m
//  NoiseComplain
//
//  Created by cheikh on 20/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPDashboardView.h"
#import "NCPArrowView.h"


#define SIZE_W (self.frame.size.width)
#define SIZE_H (self.frame.size.height)
#define CIRCLE_RADUIS SIZE_W/20
#define SIZE_W_2 SIZE_W/2
#define SIZE_H_2 SIZE_H/2
#define MAXVALUE 90
#define MINVALUE 40
#define TICK_NUM 26
#define LABLE_NUM 6
#define RADUIS_OFFSET_S 3.0
#define RADUIS_OFFSET_L 6.0
#define RADUIS (SIZE_W/2)
#define ARROW_LENGTH RADUIS*0.9
#define ARROW_WIDTH RADUIS/10

#define DEGREE_TO_RADIAN(x) ((x)*M_PI/180)
#define RADIAN_TO_DEGREE(x) ((x)/M_PI*180)

@interface NCPDashboardView()

- (void) drawTickMark:(CGContextRef) context;

@property (nonatomic, strong) NCPArrowView *arrowView;
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation NCPDashboardView

# pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView{
    [self setBackgroundColor:[UIColor clearColor]];
    self.arrowView = [[NCPArrowView alloc] initWithFrame:CGRectMake(100, 100, ARROW_WIDTH, ARROW_LENGTH)];
    [self addSubview:self.arrowView];
    
    [self initLable];
}

-(void)initLable{
    self.labels = [[NSMutableArray alloc] init];
    for (int i = 0; i < LABLE_NUM; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.layer.anchorPoint = CGPointMake(0.5, 0.0);
        label.text = [NSString stringWithFormat:@"%d",MINVALUE+i*10];
        [label sizeToFit];
        [self addSubview:label];
        [self.labels addObject:label];
    }
}

# pragma mark - layout

- (void)layoutSubviews{
    self.arrowView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.arrowView.center = CGPointMake(SIZE_W_2, SIZE_H);
    self.arrowView.bounds= CGRectMake(0, 0, ARROW_WIDTH, ARROW_LENGTH);
    
    CGPoint centerPoint = CGPointMake(SIZE_W_2, SIZE_H);
    CGFloat raduis = RADUIS*0.98;
    CGFloat angleDis = M_PI_2/(LABLE_NUM-1);
    for (int i=0; i< LABLE_NUM; i++) {
        UILabel *lable = [self.labels objectAtIndex:i];
        
        CGFloat x = centerPoint.x + (raduis-RADUIS_OFFSET_L)*cos(-M_PI_4*3+i*angleDis);
        CGFloat y = centerPoint.y + (raduis-RADUIS_OFFSET_L)*sin(-M_PI_4*3+i*angleDis);
        
        lable.center = CGPointMake(x, y);
        lable.transform = CGAffineTransformMakeRotation(-M_PI_4+i*angleDis);
    }
}

# pragma mark - draw
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context,1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    [self drawArc:context];
    [self drawTickMark:context];
}

- (void) drawDisk:(CGContextRef) context{
    CGContextBeginPath(context);
    CGContextAddArc(context, SIZE_W_2, SIZE_H, CIRCLE_RADUIS, 0, M_PI*2, 0);
    CGContextFillPath(context);
}

- (void)drawArc:(CGContextRef) context{
    CGContextBeginPath(context);
    CGContextAddArc(context, SIZE_W_2, SIZE_H, RADUIS, -M_PI_4*3, -M_PI_4, 0);
    CGContextStrokePath(context);
}

- (void) drawTickMark:(CGContextRef) context{
    CGPoint centerPoint = CGPointMake(SIZE_W_2, SIZE_H);
    CGFloat raduis = RADUIS;
    CGFloat startAngle = -M_PI_4*3;
    CGFloat angleDis = M_PI_2/25;
    CGFloat raduisOffset = 2;
    
    CGContextBeginPath(context);
    
    for (int i = 0; i<TICK_NUM; i++) {
        if(i%5==0){
            raduisOffset = RADUIS_OFFSET_L;
        }else{
            raduisOffset = RADUIS_OFFSET_S;
        }
        CGFloat curAngle = startAngle + i* angleDis;
        CGFloat x0 = centerPoint.x + (raduis+raduisOffset)*cos(curAngle);
        CGFloat y0 = centerPoint.y + (raduis+raduisOffset)*sin(curAngle);
        CGFloat x1 = centerPoint.x + (raduis-raduisOffset)*cos(curAngle);
        CGFloat y1 = centerPoint.y + (raduis-raduisOffset)*sin(curAngle);
        CGContextMoveToPoint(context, x0, y0);
        CGContextAddLineToPoint(context, x1, y1);
    }
    
    CGContextStrokePath(context);
}

#pragma mark - 操作

-(void)showValue:(double) value{
    CGFloat angle;
    if(value<MINVALUE){
        angle = -M_PI_4;
    }else if(value>MAXVALUE){
        angle = M_PI_4;
    }else{
        angle = M_PI_2*(value-MINVALUE)/(MAXVALUE-MINVALUE)-M_PI_4;
    }
    [self rotateArrow:angle];
}

-(void)rotateArrow:(CGFloat)angle{
    CGAffineTransform transform;
    transform = CGAffineTransformMakeRotation(angle);
    self.arrowView.transform = transform;
}



@end
