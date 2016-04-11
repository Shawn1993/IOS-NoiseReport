//
//  NCPComplainProgressCell.h
//  NoiseComplain
//
//  Created by mura on 4/10/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCPComplainProgress;

// 单元格位置枚举, 用于设置进度间的连接线
typedef enum NCPProgressTableCellPosition {
    NCPProgressTableCellPositionTop = 0,
    NCPProgressTableCellPositionMiddle = 1,
    NCPProgressTableCellPositionBottom = 2,
    NCPProgressTableCellPositionUnique = 3,
} NCPProgressTableCellPosition;

/*
 * 投诉进度单元格
 */
@interface NCPProgressTableCell : UITableViewCell

// 进度对象
@property(nonatomic) NCPComplainProgress *progress;

// 单元格位置
@property(nonatomic) NCPProgressTableCellPosition position;

@end
