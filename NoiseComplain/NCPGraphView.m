//
//  NCPGraphView.m
//  NoiseComplain
//
//  Created by mura on 3/16/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPGraphView.h"

@interface NCPGraphView ()

@property (weak, nonatomic) IBOutlet UIView *referencedView;

@end

@implementation NCPGraphView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"NCPGraphView" owner:self options:nil];
        [self addSubview:self.referencedView];
    }
    return self;
}

- (void)layoutSubviews {
    self.referencedView.frame = self.bounds;
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
