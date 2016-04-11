//
//  NCPGeneral.m
//  NoiseComplain
//
//  Created by mura on 3/25/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <sys/utsname.h>

#pragma mark - 常量定义

// 配置PList文件名
static NSString *const kNCPConfigPListFile = @"config";

#pragma mark - PList文件读取

NSArray *NCPReadPListArray(NSString *pList) {
    NSString *path = [[NSBundle mainBundle] pathForResource:pList ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    return array;
}

NSDictionary *NCPReadPListDictionary(NSString *pList) {
    NSString *path = [[NSBundle mainBundle] pathForResource:pList ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    return dict;
}

#pragma mark - 文件路径获取

NSString *NCPDocumentPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

#pragma mark - 设备类型获取

NSString *NCPDeviceType() {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *devString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *devTypes = NCPReadPListDictionary(NCPConfigString(@"DeviceTypePList"));
    NSString *devType = devTypes[devString];
    return devType ? devType : devString;
}

#pragma mark - 获取配置常量

// 获取一个字符串型常量
NSString *NCPConfigString(NSString *key) {
    return NCPReadPListDictionary(kNCPConfigPListFile)[key];
}

// 获取一个整型常量
NSInteger NCPConfigInteger(NSString *key) {
    return ((NSNumber *) NCPReadPListDictionary(kNCPConfigPListFile)[key]).integerValue;
}

// 获取一个无符号整型常量
NSUInteger NCPConfigUnsignedInteger(NSString *key) {
    return ((NSNumber *) NCPReadPListDictionary(kNCPConfigPListFile)[key]).unsignedIntegerValue;
}

// 获取一个浮点型常量
double NCPConfigDouble(NSString *key) {
    return ((NSNumber *) NCPReadPListDictionary(kNCPConfigPListFile)[key]).doubleValue;
}

// 获取一个数组型常量
NSArray *NCPConfigArray(NSString *key) {
    return NCPReadPListDictionary(kNCPConfigPListFile)[key];
}
