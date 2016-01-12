//
//  NCPWebRequest.h
//  NoiseComplain
//
//  Created by mura on 12/11/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!网络请求类: 用于组织和发起向服务器的一般请求*/
@interface NCPWebRequest : NSObject

/*!请求参数词典*/
@property (strong, nonatomic, readonly) NSMutableDictionary *paraDict;
/*!访问的页面, 实例化后不可修改*/
@property (copy, nonatomic, readonly) NSString *page;

#pragma mark - 获取实例

/*!工厂方法, 根据请求的页面创造一个实例*/
+ (instancetype)requestWithPage:(NSString *)page;
/*!初始化方法, 根据请求的页面初始化一个实例*/
- (instancetype)initWithPage:(NSString *)page;

#pragma mark - 设置参数

/*!设置一个参数: 整型*/
- (void)addParameter:(NSString *)key withInteger:(int)value;
/*!设置一个参数: 浮点型*/
- (void)addParameter:(NSString *)key withFloat:(float)value;
/*!设置一个参数: 布尔型*/
- (void)addParameter:(NSString *)key withBool:(BOOL)value;
/*!设置一个参数: 字符串型*/
- (void)addParameter:(NSString *)key withString:(NSString *)value;
/*!设置一个参数: 二进制型*/
- (void)addParameter:(NSString *)key withData:(NSData *)value;

/*!设置一个空的数组*/
- (void)addParameterArray:(NSString *)key;
/*!为已经存在的数组添加一个新项: 整型*/
- (void)addToArray:(NSString *)key withInteger:(int)value;
/*!为已经存在的数组添加一个新项: 浮点型*/
- (void)addToArray:(NSString *)key withFloat:(float)value;
/*!为已经存在的数组添加一个新项: 布尔型*/
- (void)addToArray:(NSString *)key withBool:(BOOL)value;
/*!为已经存在的数组添加一个新项: 字符串型*/
- (void)addToArray:(NSString *)key withString:(NSString *)value;
/*!为已经存在的数组添加一个新项: 二进制型*/
- (void)addToArray:(NSString *)key withData:(NSData *)value;

/*!是否存在指定的键*/
- (BOOL)containsKey:(NSString *)key;
/*!删除一个已经添加的键*/
- (BOOL)removeKey:(NSString *)key;

#pragma mark - 发起及响应请求

/*!发出无需处理应答的请求*/
- (BOOL)send;
/*!发出请求, 并在请求返回时进行应答*/
- (BOOL)sendWithCompletionHandler:(void(^)(NSDictionary *json))handler;

@end
