//
//  NCPComplainForm.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainForm.h"

// 当前投诉表单对象
static NCPComplainForm *gCurrentComplainForm = nil;

@implementation NCPComplainForm

#pragma mark - 初始化

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化时, 生成NSDate对象
        _date = [NSDate date];

        // 调整时区
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:_date];
        _date = [_date dateByAddingTimeInterval:interval];
    }
    return self;
}

#pragma mark - 实例设置与获取

+ (instancetype _Nullable)form {
    return [[NCPComplainForm alloc] init];
}

+ (NCPComplainForm *_Nullable)current {
    return gCurrentComplainForm;
}

+ (void)setCurrent:(NCPComplainForm *_Nullable)current {
    gCurrentComplainForm = current;
}

@end
