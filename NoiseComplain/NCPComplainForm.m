//
//  NCPComplainForm.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainForm.h"

/*!当前投诉表单(static)*/
static NCPComplainForm *gCurrentComplainForm = nil;

@implementation NCPComplainForm

- (instancetype)init {
    self = [super init];
    if (self) {
        // 根据北京时间生成
        _date = [NSDate date];
        NSTimeZone *zone =[NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:_date];
        _date = [_date dateByAddingTimeInterval:interval];
    }
    return self;
}

+ (instancetype _Nullable)form {
    return [[NCPComplainForm alloc] init];
}

+ (NCPComplainForm *_Nullable)current {
    return gCurrentComplainForm;
}

+ (void)setCurrent:(NCPComplainForm *_Nullable)current {
    gCurrentComplainForm = current;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.fId=%@", self.formId];
    [description appendFormat:@", self.date=%@", self.date];
    [description appendFormat:@", self.address=%@", self.address];
    [description appendString:@">"];
    return description;
}


@end
