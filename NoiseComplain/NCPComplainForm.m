//
//  NCPComplainForm.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCPComplainForm.h"

@implementation NCPComplainForm

#pragma mark - 初始化

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化时, 生成NSDate对象
        _date = [NSDate date];

        // 设置设备标识符
        _devId = [[UIDevice currentDevice].identifierForVendor UUIDString];
        _devType = NCPDeviceType();

        // 设置坐标系类型
        _coord = @"BD-09";

        // 为噪声强度数组进行初始化
        _intensities = [NSMutableArray arrayWithCapacity:NCPConfigUnsignedInteger(@"ComplainFormIntensitiesCapacity")];
    }
    return self;
}

#pragma mark - 日期格式转换

// 显示用长日期
- (NSString *)dateLong {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"DateFormatDisplayLong")];
    return [df stringFromDate:self.date];
}

// 显示用短日期
- (NSString *)dateShort {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"DateFormatDisplayShort")];
    return [df stringFromDate:self.date];
}

// 存储/请求用日期
- (NSString *)dateStorage {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"DateFormatStorage")];
    return [df stringFromDate:self.date];
}

// 使用存储/请求用日期设置日期值
- (void)setDateStorage:(NSString *)dateStorage {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"DateFormatStorage")];
    self.date = [df dateFromString:dateStorage];
}

#pragma mark - 默认地址获取

- (NSString *)address {
    if (self.manualAddress && self.manualAddress.length > 0) {
        return self.manualAddress;
    } else {
        return self.autoAddress;
    }
}

- (NSNumber *)latitude {
    if (self.manualLatitude && self.manualLatitude.doubleValue != 0) {
        return self.manualLatitude;
    } else {
        return self.autoLatitude;
    }
}

- (NSNumber *)longitude {
    if (self.manualLongitude && self.manualLongitude.doubleValue != 0) {
        return self.manualLongitude;
    } else {
        return self.autoLongitude;
    }
}

#pragma mark - 噪声强度记录与获取

// 获取噪声噪声记录最大值
- (BOOL)isIntensitiesFull {
    return self.intensities.count >= NCPConfigUnsignedInteger(@"ComplainFormIntensitiesCapacity");
}

// 增加一条噪声强度记录
- (void)addIntensity:(double)intensity {
    // 检查是否已经有了过多的记录
    if (self.isIntensitiesFull) {
        [self.intensities removeObjectAtIndex:0];
    }
    // 增加一条新的记录
    [self.intensities addObject:@(intensity)];
}

// 获取平均噪声强度
- (double)averageIntensity {
    if (self.intensities.count) {
        double sum = 0;
        for (NSNumber *intensity in self.intensities) {
            sum += intensity.doubleValue;
        }
        return sum / self.intensities.count;
    } else {
        return 0;
    }
}

// 获取噪声强度值JSON字符串
- (NSString *)intensitiesJSON {
    return [[NSString alloc] initWithData:
                    [NSJSONSerialization dataWithJSONObject:self.intensities
                                                    options:0
                                                      error:nil]
                                 encoding:NSUTF8StringEncoding];
}

// 使用JSON字符串赋值
- (void)setIntensitiesJSON:(NSString *)json {
    NSError *error;
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                              error:&error];
    if (!error) {
        _intensities = array;
    }
}

#pragma mark - 噪声类型与声功能区类型

// 噪声类型显示标题
- (NSString *)noiseTypeTitle {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"NoiseTypePList"));
    for (NSDictionary *type in types) {
        if (((NSNumber *) type[@"index"]).integerValue == self.noiseType) {
            return type[@"title"];
        }
    }
    return @"undefined";
}

// 噪声类型显示标题
- (NSString *)noiseTypeShort {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"NoiseTypePList"));
    for (NSDictionary *type in types) {
        if (((NSNumber *) type[@"index"]).integerValue == self.noiseType) {
            return type[@"short"];
        }
    }
    return @"undefined";
}

// 噪声类型上传内容
- (NSString *)noiseTypePost {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"NoiseTypePList"));
    for (NSDictionary *type in types) {
        if (((NSNumber *) type[@"index"]).integerValue == self.noiseType) {
            return type[@"post"];
        }
    }
    return @"undefined";
}

// 声功能区类型标题
- (NSString *)sfaTypeTitle {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"SfaTypePList"));
    for (NSDictionary *type in types) {
        if (((NSNumber *) type[@"index"]).intValue == self.sfaType) {
            return type[@"title"];
        }
    }
    return @"undefined";
}

// 声功能区显示标题
- (NSString *)sfaTypeShort {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"SfaTypePList"));
    for (NSDictionary *type in types) {
        if (((NSNumber *) type[@"index"]).integerValue == self.sfaType) {
            return type[@"short"];
        }
    }
    return @"undefined";
}

// 声功能区上传内容
- (NSString *)sfaTypePost {
    NSArray *types = NCPReadPListArray(NCPConfigString(@"SfaTypePList"));
    for (NSDictionary *type in types) {
        if (((NSNumber *) type[@"index"]).integerValue == self.sfaType) {
            return type[@"post"];
        }
    }
    return @"undefined";
}

@end
