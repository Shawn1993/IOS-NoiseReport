//
//  NCPMeterView.h
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCPMeterView : UIView

@property(nonatomic, assign, setter=setValue:) float value;

- (void)setValueWithLable:(float)value;

@end
