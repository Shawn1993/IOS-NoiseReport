//
//  NCPWebParameter.h
//  NoiseComplain
//
//  Created by mura on 12/16/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!网络请求参数类型枚举*/
typedef enum : NSUInteger {
    NCPWebInteger,
    NCPWebFloat,
    NCPWebBool,
    NCPWebString,
    NCPWebData,
    NCPWebArray
} NCPWebParaTypeEnum;

/*!网络请求参数类: 封装指定类型的键值对, 用于组织网络请求*/
@interface NCPWebParameter : NSObject

/*!参数类型*/
@property(assign, nonatomic, readonly) NCPWebParaTypeEnum type;

/*!内容(NSNumber *, NSString *, NSArray *, NSData *)*/
@property(strong, nonatomic) id content;

#pragma mark - 用于快速获取实例的工厂方法

/*!传入类型的初始化方法*/
- (instancetype)initWithType:(NCPWebParaTypeEnum)type;

/*!创建一个参数对象: 整型*/
+ (instancetype)parameterWithInteger:(int)value;

/*!创建一个参数对象: 浮点型*/
+ (instancetype)parameterWithFloat:(float)value;

/*!创建一个参数对象: 布尔型*/
+ (instancetype)parameterWithBool:(BOOL)value;

/*!创建一个参数对象: 字符串型*/
+ (instancetype)parameterWithString:(NSString *)value;

/*!创建一个参数对象: 二进制型*/
+ (instancetype)parameterWithData:(NSData *)value;

/*!创建一个空数组*/
+ (instancetype)array;

@end
