//
//  NCPWebRequest.h
//  NoiseComplain
//
//  Created by mura on 12/11/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  网络请求类: 用于组织和发起向服务器的一般请求
 */
@interface NCPWebRequest : NSObject

/*!
 *  请求参数词典
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *paraDict;

/*!
 *  访问的页面, 实例化后不可从外部修改
 */
@property (copy, nonatomic, readonly) NSString *page;

#pragma mark - 获取实例

/*!
 *  工厂方法, 根据请求的页面创造一个实例
 *
 *  @param page 要请求的页面名称
 *
 *  @return 初始化后的实例
 */
+ (instancetype)requestWithPage:(NSString *)page;

/*!
 *  初始化方法, 根据请求的页面初始化一个实例
 *
 *  @param page 要请求的页面名称
 *
 *  @return 初始化后的实例
 */
- (instancetype)initWithPage:(NSString *)page;

#pragma mark - 设置参数

/*!
 *  设置一个参数: 整型
 *  <p>
 *  当传入的键已经存在的时候, 会覆盖原有的内容
 *
 *  @param key   键
 *  @param value 值
 */
- (void)addParameter:(NSString *)key withInteger:(int)value;

/*!
 *  设置一个参数: 浮点型
 *  <p>
 *  当传入的键已经存在的时候, 会覆盖原有的内容
 *
 *  @param key   键
 *  @param value 值
 */
- (void)addParameter:(NSString *)key withFloat:(float)value;

/*!
 *  设置一个参数: 布尔型
 *  <p>
 *  当传入的键已经存在的时候, 会覆盖原有的内容
 *
 *  @param key   键
 *  @param value 值
 */
- (void)addParameter:(NSString *)key withBool:(BOOL)value;

/*!
 *  设置一个参数: 字符串型
 *  <p>
 *  当传入的键已经存在的时候, 会覆盖原有的内容
 *
 *  @param key   键
 *  @param value 值
 */
- (void)addParameter:(NSString *)key withString:(NSString *)value;

/*!
 *  设置一个参数: 二进制型
 *  <p>
 *  当传入的键已经存在的时候, 会覆盖原有的内容
 *
 *  @param key   键
 *  @param value 值
 */
- (void)addParameter:(NSString *)key withData:(NSData *)value;

/*!
 *  设置一个空的数组
 *  <p>
 *  当传入的键已经存在的时候, 会覆盖原有的内容
 *
 *  @param key 数组的键
 */
- (void)addParameterArray:(NSString *)key;

/*!
 *  为已经存在的数组添加一个新项: 整型
 *  <p>
 *  如果数组的键无效或不是指向数组, 就什么也不做
 *
 *  @param key   数组的键
 *  @param value 值
 */
- (void)addToArray:(NSString *)key withInteger:(int)value;

/*!
 *  为已经存在的数组添加一个新项: 浮点型
 *  <p>
 *  如果数组的键无效或不是指向数组, 就什么也不做
 *
 *  @param key   数组的键
 *  @param value 值
 */
- (void)addToArray:(NSString *)key withFloat:(float)value;

/*!
 *  为已经存在的数组添加一个新项: 布尔型
 *  <p>
 *  如果数组的键无效或不是指向数组, 就什么也不做
 *
 *  @param key   数组的键
 *  @param value 值
 */
- (void)addToArray:(NSString *)key withBool:(BOOL)value;

/*!
 *  为已经存在的数组添加一个新项: 字符串型
 *  <p>
 *  如果数组的键无效或不是指向数组, 就什么也不做
 *
 *  @param key   数组的键
 *  @param value 值
 */
- (void)addToArray:(NSString *)key withString:(NSString *)value;

/*!
 *  为已经存在的数组添加一个新项: 二进制型
 *  <p>
 *  如果数组的键/类型无效或不是指向数组, 就什么也不做
 *
 *  @param key   数组的键
 *  @param value 值
 */
- (void)addToArray:(NSString *)key withData:(NSData *)value;

/*!
 *  检查是否已经添加了指定的键
 *
 *  @param key 键
 *
 *  @return <b>YES/NO</b>
 */
- (BOOL)containsKey:(NSString *)key;

/*!
 *  删除一个已经添加的键
 *
 *  @param key 键
 *
 *  @return 如键存在并已删除, 返回<b>YES</b>, 否则返回<b>NO</b>
 */
- (BOOL)removeKey:(NSString *)key;

#pragma mark - 发起及响应请求

/*!
 *  发出无需处理应答的请求
 *
 *  @return 成功发出请求返回<b>YES</b>, 否则返回<b>NO</b>
 */
- (BOOL)send;

/*!
 *  发出请求, 并在请求返回时进行应答
 *
 *  @param handler 用于应答的代码块, 会传入一个NCPWebResponse对象作为应答内容
 *
 *  @return 成功发出请求返回<b>YES</b>, 否则返回<b>NO</b>
 */
- (BOOL)sendWithCompletionHandler:(void(^)(NSDictionary *json))handler;

@end
