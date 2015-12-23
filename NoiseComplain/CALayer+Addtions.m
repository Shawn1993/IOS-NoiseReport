//
//  CALayer+Addtions.m
//  NoiseComplain
//
//  Created by cheikh on 23/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//


#import "CALayer+Addtions.h"
#import <objc/runtime.h>
@implementation CALayer (Additions)

- (UIColor *)borderColorFromUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}


- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
