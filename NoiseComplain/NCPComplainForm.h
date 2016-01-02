//
//  NCPComplainForm.h
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  投诉表单类
 */
@interface NCPComplainForm : NSObject

/*!
 *  描述信息
 */
@property (nullable, nonatomic, retain) NSString *comment;

/*!
 *  日期
 */
@property (nonnull, nonatomic, retain) NSDate *date;

/*!
 *  噪声强度(float)
 */
@property (nullable, nonatomic, retain) NSNumber *intensity;

/*!
 *  纬度(float)
 */
@property (nullable, nonatomic, retain) NSNumber *latitude;

/*!
 *  经度(float)
 */
@property (nullable, nonatomic, retain) NSNumber *longitude;

/*!
 *  海拔(float)
 */
@property (nullable, nonatomic, retain) NSNumber *altitude;

/*!
 *  描述图片
 */
@property (nullable, nonatomic, retain) NSData *image;

/*!
 *  声功能区类型
 */
@property (nullable, nonatomic, retain) NSString *sfaType;

/*!
 *  噪声类型
 */
@property (nullable, nonatomic, retain) NSString *noiseType;

/*!
 *  默认工厂方法
 *
 *  @return 生成的新实体
 */
+ (instancetype _Nullable)form;

/*!
 *  获取当前正在填写的表单(方便跨视图调用)
 *
 *  @return 在表单填写过程中返回当前的表单对象, 否则返回<b>nil</b>
 */
+ ( NCPComplainForm * _Nullable)current;

/*!
 *  设置当前正在填写的表单(方便跨视图调用)
 *
 *  @param current 设置的值
 */
+ (void)setCurrent:(NCPComplainForm * _Nullable)current;

@end
