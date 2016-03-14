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

+ (instancetype)parameterWithInteger:(int)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebInteger];
    para.content = @(value);
    return para;
}

+ (instancetype)parameterWithFloat:(float)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebFloat];
    para.content = @(value);
    return para;
}

+ (instancetype)parameterWithBool:(BOOL)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebBool];
    para.content = @(value);
    return para;
}

+ (instancetype)parameterWithString:(NSString *)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebString];
    para.content = value;
    return para;
}

+ (instancetype)parameterWithData:(NSData *)value {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebData];
    para.content = value;
    return para;
}

+ (instancetype)array {
    NCPWebParameter *para = [[NCPWebParameter alloc] initWithType:NCPWebArray];
    para.content = [NSMutableArray array];
    return para;
}

@end
