//
//  NCPComplainForm.h
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!投诉表单类*/
@interface NCPComplainForm : NSObject

/*!表格编号(int32)*/
@property(nonnull, nonatomic, strong) NSNumber *formId;
/*!描述信息*/
@property(nullable, nonatomic, strong) NSString *comment;
/*!日期*/
@property(nonnull, nonatomic, strong) NSDate *date;
/*!噪声强度(float)*/
@property(nullable, nonatomic, strong) NSNumber *intensity;
/*!地址信息*/
@property(nullable, nonatomic, strong) NSString *address;
/*!纬度(float)*/
@property(nullable, nonatomic, strong) NSNumber *latitude;
/*!经度(float)*/
@property(nullable, nonatomic, strong) NSNumber *longitude;
/*!描述图片*/
@property(nullable, nonatomic, strong) NSData *image;
/*!声功能区类型*/
@property(nullable, nonatomic, strong) NSString *sfaType;
/*!噪声类型*/
@property(nullable, nonatomic, strong) NSString *noiseType;

/*!默认工厂方法*/
+ (instancetype _Nullable)form;

/*!获取当前正在填写的表单(方便跨视图调用)*/
+ (NCPComplainForm *_Nullable)current;

/*!设置当前正在填写的表单(方便跨视图调用)*/
+ (void)setCurrent:(NCPComplainForm *_Nullable)current;

@end
