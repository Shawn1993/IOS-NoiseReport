//
//  NCPGeneral.h
//  NoiseComplain
//
//  Created by mura on 3/25/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

#pragma mark - PList读取

// 获取PList数组对象
NSArray *NCPReadPListArray(NSString *pList);

// 获取PList字典对象
NSDictionary *NCPReadPListDictionary(NSString *pList);

#pragma mark - 本机信息获取

// 获取Document目录路径
NSString *NCPDocumentPath();

// 获取本机设备类型
NSString *NCPDeviceType();

#pragma mark - 获取配置常量

// 获取一个字符串常量
NSString *NCPConfigString(NSString *key);

// 获取一个整型常量
NSInteger NCPConfigInteger(NSString *key);

// 获取一个无符号整型常量
NSUInteger NCPConfigUnsignedInteger(NSString *key);

// 获取一个浮点型常量
double NCPConfigDouble(NSString *key);

// 获取一个数组型乘凉
NSArray *NCPConfigArray(NSString *key);
