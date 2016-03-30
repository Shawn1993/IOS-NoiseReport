//
//  NCPGeneral.m
//  NoiseComplain
//
//  Created by mura on 3/25/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <sys/utsname.h>

#pragma mark - 常量定义

NSString* kNCPConfigPListFile = @"config";

#pragma mark - 日期格式化

NSString *NCPStringFormDate(NSDate *date) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"ServerDateFormat")];
    return [df stringFromDate:date];
}

NSDate *NCPDateFormString(NSString *string) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:NCPConfigString(@"ServerDateFormat")];
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

    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";

    //iPod

    if ([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";

    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"]) return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"]) return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"]) return @"iPad mini (CDMA)";

    if ([deviceString isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"]) return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"]) return @"iPad 3 (4G)";
    if ([deviceString isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"]) return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"]) return @"iPad 4 (CDMA)";

    if ([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2";

    if ([deviceString isEqualToString:@"i386"]) return @"Simulator_i386";
    if ([deviceString isEqualToString:@"x86_64"]) return @"Simulator_x86_64";

    if ([deviceString isEqualToString:@"iPad4,4"] ||
            [deviceString isEqualToString:@"iPad4,5"] ||
            [deviceString isEqualToString:@"iPad4,6"])
        return @"iPad mini 2";

    if ([deviceString isEqualToString:@"iPad4,7"] ||
            [deviceString isEqualToString:@"iPad4,8"] ||
            [deviceString isEqualToString:@"iPad4,9"])
        return @"iPad mini 3";

    return deviceString;
}

#pragma mark - 获取配置常量

// 获取一个字符串型常量
NSString *NCPConfigString(NSString *key) {
    return NCPReadPListDictionary(kNCPConfigPListFile)[key];
}

// 获取一个整型常量
int NCPConfigInteger(NSString *key) {
    return ((NSNumber *)NCPReadPListDictionary(kNCPConfigPListFile)[key]).intValue;
}

// 获取一个浮点型常量
double NCPConfigDouble(NSString *key) {
    return ((NSNumber *)NCPReadPListDictionary(kNCPConfigPListFile)[key]).doubleValue;
}
