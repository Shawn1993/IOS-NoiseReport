//
//  NCPSQLiteDAO.h
//  NoiseComplain
//
//  Created by mura on 3/26/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCPComplainForm.h"

@interface NCPSQLiteDAO : NSObject

// 插入投诉表单
+ (BOOL)createComplainForm:(NCPComplainForm *)form;

// 查询全部投诉表单
+ (NSArray *)retrieveAllComplainForm;

// 删除一条投诉表单
+ (BOOL)deleteComplainForm:(NCPComplainForm *)form;

@end
