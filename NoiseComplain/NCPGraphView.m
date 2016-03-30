//
//  NCPGraphView.m
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPGraphView.h"

@interface NCPGraphView ()

#pragma mark - Xib输出口

@property (weak, nonatomic) IBOutlet UIView *referencedView;

@end

@implementation NCPGraphView

#pragma mark - 初始化与布局

// 初始化方法
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
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

#pragma mark - 绘制方法

// 绘制方法
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
