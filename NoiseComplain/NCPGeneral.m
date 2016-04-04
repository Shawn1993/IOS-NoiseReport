//
//  NCPGeneral.m
//  NoiseComplain
//
//  Created by mura on 3/25/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <sys/utsname.h>

#pragma mark - 常量定义

NSString *kNCPConfigPListFile = @"config";

#pragma mark - 日期格式化

NSString *NCPRequestFormatStringFormDate(NSDate *date) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"RequestDateFormat")];
    return [df stringFromDate:date];
}

NSDate *NCPDateFormRequestFormatString(NSString *string) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"RequestDateFormat")];
    return [df dateFromString:string];
}

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
int NCPConfigInteger(NSString *key) {
    return ((NSNumber *) NCPReadPListDictionary(kNCPConfigPListFile)[key]).intValue;
}

// 获取一个浮点型常量
double NCPConfigDouble(NSString *key) {
    return ((NSNumber *) NCPReadPListDictionary(kNCPConfigPListFile)[key]).doubleValue;
}
