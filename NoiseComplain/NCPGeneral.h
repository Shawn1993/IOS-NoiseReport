//
//  NCPGeneral.h
//  NoiseComplain
//
//  Created by mura on 3/25/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 通用常量定义

#pragma mark - 通用公用函数

// 根据自定义格式格式化NSDate
NSString *NCPStringFormDate(NSDate *date);

// 根据自定义格式获取NSDate对象
NSDate *NCPDateFormString(NSString *string);

// 获取PList数组对象
NSArray *NCPReadPListArray(NSString *pList);

// 获取PList字典对象
NSDictionary *NCPReadPListDictionary(NSString *pList);

// 获取Document目录路径
NSString *NCPDocumentPath();
