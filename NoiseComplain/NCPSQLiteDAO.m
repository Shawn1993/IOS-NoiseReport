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
    if (![NCPSQLiteDAO database:db containsTable:@"complain_form"]) {
        // 创建新表
        [db executeUpdate:@"CREATE TABLE complain_form ("
                "form_id INTEGER PRIMARY KEY,"
                "dev_id TEXT,"
                "comment TEXT,"
                "date TEXT,"
                "intensity REAL,"
                "address TEXT,"
                "latitude REAL,"
                "longitude REAL,"
                "coord TEXT,"
                "sfa_type TEXT,"
                "noise_type TEXT"
                ")"];
    }

    // 插入新投诉表单
    BOOL result = [db executeUpdate:@"INSERT INTO complain_form"
                                            "(form_id, dev_id, comment,"
                                            "date, intensity, address,"
                                            "latitude, longitude, coord,"
                                            "sfa_type, noise_type)"
                                            "VALUES (?,?,?,?,?,?,?,?,?,?,?)",
                                    form.formId, form.devId, form.comment, NCPStringFormDate(form.date), form.intensity,
                                    form.address, form.latitude, form.longitude, form.coord, form.sfaType, form.noiseType
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
    if (![NCPSQLiteDAO database:db containsTable:@"complain_form"]) {
        // 返回空数组
        return array;
    }

    // 获取查询结果
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM complain_form"];
    while (rs.next) {
        // 新建ComplainForm对象并赋值
        NCPComplainForm *form = [[NCPComplainForm alloc] init];
        form.formId = @([rs longForColumn:@"form_id"]);
        form.devId = [rs stringForColumn:@"dev_id"];
        form.comment = [rs stringForColumn:@"comment"];
        form.date = NCPDateFormString([rs stringForColumn:@"date"]);
        form.intensity = @([rs doubleForColumn:@"intensity"]);
        form.address = [rs stringForColumn:@"address"];
        form.latitude = @([rs doubleForColumn:@"latitude"]);
        form.longitude = @([rs doubleForColumn:@"longitude"]);
        form.coord = [rs stringForColumn:@"coord"];
        form.sfaType = [rs stringForColumn:@"sfa_type"];
        form.noiseType = [rs stringForColumn:@"noise_type"];
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
