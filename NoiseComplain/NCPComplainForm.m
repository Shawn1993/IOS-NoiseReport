//
//  NCPComplainForm.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainForm.h"

/*!
 *  当前投诉表单(static)
 */
static NCPComplainForm *gCurrentComplainForm = nil;

@implementation NCPComplainForm

- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
    }
    return self;
}

+ (instancetype _Nullable)form {
    return [[NCPComplainForm alloc] init];
}

+ ( NCPComplainForm * _Nullable)current {
    return gCurrentComplainForm;
}

+ (void)setCurrent:(NCPComplainForm * _Nullable)current {
    gCurrentComplainForm = current;
}

@end
