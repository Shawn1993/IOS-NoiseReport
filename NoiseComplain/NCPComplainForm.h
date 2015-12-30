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
+ (instancetype)form;


@end
