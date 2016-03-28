//
//  NCPSQLiteDAO.m
//  NoiseComplain
//
//  Created by mura on 3/26/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPSQLiteDAO.h"
#import "NCPComplainForm.h"

#import "FMDB.h"

#pragma mark - 常量定义

// 常量: 数据库文件名
static NSString *kNCPSQLiteFileName = @"ncp.sqlite";

@implementation NCPSQLiteDAO

#pragma mark - SQLite通用方法

// 获取(已经开启的)FMDB数据库对象
+ (FMDatabase *)database {
    NSString *path = [NCPDocumentPath() stringByAppendingString:kNCPSQLiteFileName];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if (db) {
        if ([db open]) {
            return db;
        }
    }
    return nil;
}

// 检查指定的表格是否存在
+ (BOOL)database:(FMDatabase *)db containsTable:(NSString *)table {
    FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as 'count' FROM sqlite_master WHERE type = 'table' AND name = ?", table];
    while (rs.next) {
        BOOL result = [rs intForColumn:@"count"] > 0;
        [rs close];
        return result;
    }
    return NO;
}

#pragma mark - ComplainForm增删改查

// 插入投诉表单
+ (BOOL)createComplainForm:(NCPComplainForm *)form {

    // 获取数据库对象
    FMDatabase *db = [NCPSQLiteDAO database];
    if (!db) {
        return false;
    }

    // 检查表是否存在, 若不存在则创建
    if (![NCPSQLiteDAO database:db containsTable:@"complainForm"]) {
        // 创建新表
        [db executeUpdate:@"CREATE TABLE complainForm ("
                "formId INTEGER PRIMARY KEY,"
                "date TEXT,"
                "averageIntensity REAL,"
                "intensities TEXT,"
                "coord TEXT,"
                "autoAddress TEXT,"
                "autoLatitude REAL,"
                "autoLongitude REAL,"
                "manualAddress TEXT,"
                "manualLatitude REAL,"
                "manualLongitude REAL,"
                "sfaType TEXT,"
                "noiseType TEXT,"
                "comment TEXT"
                ")"];
    }

    // 插入新投诉表单
    BOOL result = [db executeUpdate:@"INSERT INTO complainForm "
                                            "(formId,"
                                            "date,"
                                            "averageIntensity,"
                                            "intensities,"
                                            "coord,"
                                            "autoAddress,"
                                            "autoLatitude,"
                                            "autoLongitude,"
                                            "manualAddress,"
                                            "manualLatitude,"
                                            "manualLongitude,"
                                            "sfaType,"
                                            "noiseType,"
                                            "comment) "
                                            "VALUES (?,'?',?,'?','?','?',?,?,'?',?,?,'?','?','?')",
                                    form.formId,
                                    NCPStringFormDate(form.date),
                                    form.averageIntensity,
                                    form.intensitiesJSON,
                                    form.coord,
                                    form.autoAddress,
                                    form.autoLatitude,
                                    form.autoLongitude,
                                    form.manualAddress,
                                    form.manualLatitude,
                                    form.manualLongitude,
                                    form.sfaType,
                                    form.noiseType,
                                    form.comment
    ];

    [db close];
    return result;
}

// 查询全部投诉表单
+ (NSArray *)retrieveAllComplainForm {

    // 准备储存结果的Array
    NSMutableArray *array = [NSMutableArray array];

    // 获取数据库对象
    FMDatabase *db = [NCPSQLiteDAO database];
    if (!db) {
        // 返回空数组
        return array;
    }

    // 检查表格是否存在
    if (![NCPSQLiteDAO database:db containsTable:@"complainForm"]) {
        // 返回空数组
        return array;
    }

    // 获取查询结果
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM complainForm"];
    while (rs.next) {
        // 新建ComplainForm对象并赋值
        NCPComplainForm *form = [[NCPComplainForm alloc] init];
        form.formId = @([rs longForColumn:@"formId"]);
        form.date = NCPDateFormString([rs stringForColumn:@"date"]);

        form.intensitiesJSON = [rs stringForColumn:@"intensities"];
        if (form.intensities.count == 0) {
            [form addIntensity:[rs doubleForColumn:@"averageIntensity"]];
        }

        form.coord = [rs stringForColumn:@"coord"];
        form.autoAddress = [rs stringForColumn:@"autoAddress"];
        form.autoLatitude = @([rs doubleForColumn:@"autoLatitude"]);
        form.autoLongitude = @([rs doubleForColumn:@"autoLongitude"]);

        form.manualAddress = [rs stringForColumn:@"manualAddress"];
        form.manualLatitude = @([rs doubleForColumn:@"manualLatitude"]);
        form.manualLongitude = @([rs doubleForColumn:@"manualLongitude"]);

        form.sfaType = [rs stringForColumn:@"sfaType"];
        form.noiseType = [rs stringForColumn:@"noiseType"];
        form.comment = [rs stringForColumn:@"comment"];

        [array addObject:form];
    }

    [rs close];
    [db close];
    return array;
}

+ (BOOL)deleteComplainForm:(NCPComplainForm *)form {

    // 获取数据库对象
    FMDatabase *db = [NCPSQLiteDAO database];
    if (!db) {
        // 返回空数组
        return NO;
    }

    BOOL result = [db executeUpdate:@"DELETE FROM complain_form WHERE form_id = ?", form.formId];

    [db close];
    return result;
}

@end
