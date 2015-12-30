//
//  NCPComplainForm.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainForm.h"

@implementation NCPComplainForm

- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
    }
    return self;
}

+ (instancetype)form {
    return [[NCPComplainForm alloc] init];
}

@end
