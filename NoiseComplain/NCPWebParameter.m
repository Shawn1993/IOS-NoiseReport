//
//  NCPWebParameter.m
//  NoiseComplain
//
//  Created by mura on 12/16/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPWebParameter.h"

@implementation NCPWebParameter

- (instancetype)initWithType:(NCPWebParaTypeEnum)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

+ (instancetype)paraWithInteger:(int)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebInteger];
    para.content = [NSNumber numberWithInt:value];
    return para;
}

+ (instancetype)paraWithFloat:(float)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebFloat];
    para.content = [NSNumber numberWithFloat:value];
    return para;
}

+ (instancetype)paraWithBool:(BOOL)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebBool];
    para.content = [NSNumber numberWithBool:value];
    return para;
}

+ (instancetype)paraWithString:(NSString *)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebString];
    para.content = value;
    return para;
}

+ (instancetype)paraWithData:(NSData *)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebData];
    para.content = value;
    return para;
}

+ (instancetype)arrayWithType:(NCPWebParaTypeEnum)type {
    if ([NCPWebParameter isArray:type]) {
        NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:type];
        para.content = [NSMutableArray array];
        return para;
    } else {
        return nil;
    }
}

- (NSString *)prefix {
    switch (_type) {
        case NCPWebInteger:
            return @"i";
        case NCPWebFloat:
            return @"f";
        case NCPWebBool:
            return @"b";
        case NCPWebString:
            return @"s";
        case NCPWebData:
            return @"d";
            
        case NCPWebIntegerArray:
            return @"I";
        case NCPWebFloatArray:
            return @"F";
        case NCPWebBoolArray:
            return @"B";
        case NCPWebStringArray:
            return @"S";
        case NCPWebDataArray:
            return @"D";
        default:
            return nil;
    }
}

- (BOOL)isArray {
    return [NCPWebParameter isArray:_type];
}

+ (BOOL)isArray:(NCPWebParaTypeEnum)type {
    switch (type) {
        case NCPWebIntegerArray:
        case NCPWebFloatArray:
        case NCPWebBoolArray:
        case NCPWebStringArray:
        case NCPWebDataArray:
            return YES;
        default:
            return NO;
    }
}


@end
