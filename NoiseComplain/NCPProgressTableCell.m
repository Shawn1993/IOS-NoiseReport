//
//  NCPComplainProgressCell.m
//  NoiseComplain
//
//  Created by mura on 4/10/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPProgressTableCell.h"

@interface NCPProgressTableCell ()

#pragma mark - Stroyboard输出口

// 进度图标
@property(weak, nonatomic) IBOutlet UIImageView *imageProgress;
// 上方连接线
@property(weak, nonatomic) IBOutlet UIView *lineTop;
// 下方链接线
@property(weak, nonatomic) IBOutlet UIView *lineBottom;

@end

@implementation NCPProgressTableCell

#pragma mark - 单元格生命周期

- (void)awakeFromNib {
    [super awakeFromNib];
    // 初始化
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // 点击事件
}

#pragma mark - 单元格位置

// 获取单元格位置
- (NCPProgressTableCellPosition)position {
    if (self.lineTop.hidden) {
        if (self.lineBottom.hidden) {
            return NCPProgressTableCellPositionUnique;
        } else {
            return NCPProgressTableCellPositionTop;
        }
    } else {
        if (self.lineBottom.hidden) {
            return NCPProgressTableCellPositionBottom;
        } else {
            return NCPProgressTableCellPositionMiddle;
        }
    }
}

// 设置单元格位置
- (void)setPosition:(NCPProgressTableCellPosition)position {
    switch (position) {
        case NCPProgressTableCellPositionTop:
            self.lineTop.hidden = YES;
            self.lineBottom.hidden = NO;
            break;
        case NCPProgressTableCellPositionMiddle:
            self.lineTop.hidden = NO;
            self.lineBottom.hidden = NO;
            break;
        case NCPProgressTableCellPositionBottom:
            self.lineTop.hidden = NO;
            self.lineBottom.hidden = YES;
            break;
        case NCPProgressTableCellPositionUnique:
            self.lineTop.hidden = YES;
            self.lineBottom.hidden = YES;
            break;
    }
}

@end
