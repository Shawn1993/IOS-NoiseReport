//
//  NCPGeneral.m
//  NoiseComplain
//
//  Created by mura on 3/25/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#pragma mark - 通用常量定义

#pragma mark - 静态常量定义

static NSString *kNCPDateFormat = @"yyyy-MM-dd-HH-mm-ss";

#pragma mark - 日期格式化

NSString *NCPStringFormDate(NSDate *date) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kNCPDateFormat];
    return [df stringFromDate:date];
}

NSDate *NCPDateFormString(NSString *string) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kNCPDateFormat];
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
