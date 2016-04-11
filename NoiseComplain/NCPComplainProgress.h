//
//  NCPComplainProcess.h
//  NoiseComplain
//
//  Created by mura on 4/7/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCPComplainForm;

/*
 * 投诉受理进度类, 每个实例对应一次进度受理
 */
@interface NCPComplainProgress : NSObject

#pragma mark - 字段

// 所属表单ID(long)
@property(nonatomic) NSNumber *formId;

// 进度发生时间
@property(nonatomic) NSDate *date;

// 进度标题
@property(nonatomic) NSString *title;
// 进度描述
@property(nonatomic) NSString *comment;
// 进度详细信息(字典形式)
@property(nonatomic) NSMutableDictionary *details;


@end
