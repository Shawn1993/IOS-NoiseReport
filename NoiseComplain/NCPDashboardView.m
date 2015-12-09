//
//  NCPDashboardView.m
//  NoiseComplain
//
//  Created by cheikh on 3/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPDashboardView.h"
#define DEGREE_TO_RADIAN(x) ((x)*3.14/180)
#define RADIAN_TO_DEGREE(x) ((x)/3.14*180)

@interface NCPDashboardView()


@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;

@end

@implementation NCPDashboardView

/** 旋转箭头：角度 */
- (void) rotateArrow:(double) degree{
    CGFloat halfHeight = _imageViewArrow.layer.bounds.size.height/2;
    
    CGAffineTransform transform =CGAffineTransformMakeTranslation(0, halfHeight);
    transform = CGAffineTransformRotate(transform, DEGREE_TO_RADIAN(degree));
    transform = CGAffineTransformTranslate(transform,-0,-halfHeight);
    _imageViewArrow.transform = transform;
}

@end
