//
//  NCPSQLiteDAO.h
//  NoiseComplain
//
//  Created by mura on 3/26/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCPComplainForm;

@interface NCPSQLiteDAO : NSObject

#pragma mark - ComplainForm操作

// 插入投诉表单
+ (BOOL)insertComplainForm:(NCPComplainForm *)form;

// 查询全部投诉表单
+ (NSArray *)selectAllComplainForm;

// 删除一条投诉表单
+ (BOOL)deleteComplainForm:(NCPComplainForm *)form;

@end
