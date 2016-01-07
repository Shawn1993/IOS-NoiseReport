//
//  NCPWebParameter.h
//  NoiseComplain
//
//  Created by mura on 12/16/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  网络请求参数类型枚举
 */
typedef enum : NSUInteger {
    NCPWebInteger,
    NCPWebFloat,
    NCPWebBool,
    NCPWebString,
    NCPWebData,
    NCPWebArray
} NCPWebParaTypeEnum;

/*!
 *  网络请求参数类: 封装了一组指定类型的键值对, 用于组织网络请求
 */
@interface NCPWebParameter : NSObject

/*!
 *  参数类型
 */
@property (assign, nonatomic, readonly) NCPWebParaTypeEnum type;

/*!
 *  内容(NSNumber *, NSString *, NSArray *, NSData *类型)
 */
@property (strong, nonatomic) id content;

#pragma mark - 用于快速获取实例的工厂方法

/*!
 *  传入类型的初始化方法
 *
 *  @param type 类型枚举值
 *
 *  @return 初始化后的实例
 */
- (instancetype)initWithType:(NCPWebParaTypeEnum)type;

/*!
 *  创建一个参数对象: 整型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)parameterWithInteger:(int)value;

/*!
 *  创建一个参数对象: 浮点型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)parameterWithFloat:(float)value;

/*!
 *  创建一个参数对象: 布尔型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)parameterWithBool:(BOOL)value;

/*!
 *  创建一个参数对象: 字符串型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)parameterWithString:(NSString *)value;

/*!
 *  创建一个参数对象: 二进制型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)parameterWithData:(NSData *)value;

/*!
 *  创建一个空数组
 *
 *  @param type 数组类型
 *
 *  @return 数组对象
 */
+ (instancetype)array;

@end
