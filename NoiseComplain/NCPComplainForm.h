//
//  NCPComplainForm.h
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 投诉表单对象类, 保存封装一次投诉所包含的所有信息
 */
@interface NCPComplainForm : NSObject

#pragma mark - 投诉信息字段

// 表格编号(long)
@property(nullable, nonatomic, strong) NSNumber *formId;
// 设备ID
@property(nonnull, nonatomic, strong) NSString *devId;
// 描述信息
@property(nullable, nonatomic, strong) NSString *comment;
// 日期
@property(nonnull, nonatomic, strong) NSDate *date;
// 噪声强度(float)
@property(nullable, nonatomic, strong) NSNumber *intensity;
// 地址信息
@property(nullable, nonatomic, strong) NSString *address;
// 纬度(float)
@property(nullable, nonatomic, strong) NSNumber *latitude;
// 经度(float)
@property(nullable, nonatomic, strong) NSNumber *longitude;
// 坐标系
@property(nonnull, nonatomic, strong) NSString *coord;
// 声功能区类型
@property(nullable, nonatomic, strong) NSString *sfaType;
// 噪声类型
@property(nullable, nonatomic, strong) NSString *noiseType;

#pragma mark - 类方法

// 工厂方法
+ (instancetype _Nullable)form;

// 获取当前正在填写的表单(方便跨视图调用)
+ (NCPComplainForm *_Nullable)current;

// 设置当前正在填写的表单(方便跨视图调用)
+ (void)setCurrent:(NCPComplainForm *_Nullable)current;

@end
