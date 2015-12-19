//
//  NCPWebParameter.h
//  NoiseComplain
//
//  Created by mura on 12/16/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NCPWEBPARATYPEENUM_DEFINE
#define NCPWEBPARATYPEENUM_DEFINE

/*!
 *  网络请求参数类型枚举
 */
typedef enum : NSUInteger {
    NCPWebInteger,
    NCPWebFloat,
    NCPWebBool,
    NCPWebString,
    NCPWebData,
    
    NCPWebIntegerArray,
    NCPWebFloatArray,
    NCPWebBoolArray,
    NCPWebStringArray,
    NCPWebDataArray,
} NCPWebParaTypeEnum;

#endif

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
+ (instancetype)paraWithInteger:(int)value;

/*!
 *  创建一个参数对象: 浮点型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)paraWithFloat:(float)value;

/*!
 *  创建一个参数对象: 布尔型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)paraWithBool:(BOOL)value;

/*!
 *  创建一个参数对象: 字符串型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)paraWithString:(NSString *)value;

/*!
 *  创建一个参数对象: 二进制型
 *
 *  @param value 值
 *
 *  @return 参数对象
 */
+ (instancetype)paraWithData:(NSData *)value;

/*!
 *  创建一个空数组
 *
 *  @param type 数组类型
 *
 *  @return 数组对象
 */
+ (instancetype)arrayWithType:(NCPWebParaTypeEnum)type;

#pragma mark - 类型前缀

/*!
 *  根据参数的类型, 获取相应的类型前缀
 *
 *  @return 前缀
 */
- (NSString *)prefix;

/*!
 *  返回此参数是不是数组, 简化判断
 *
 *  @return <b>YES/NO</b>
 */
- (BOOL)isArray;

/*!
 *  返回此类型是不是数组, 简化判断
 *
 *  @param type 类型枚举
 *
 *  @return <b>YES/NO</b>
 */
+ (BOOL)isArray:(NCPWebParaTypeEnum)type;


@end
