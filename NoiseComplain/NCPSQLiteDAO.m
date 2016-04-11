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

@implementation NCPSQLiteDAO

// 获取(已经开启的)FMDB数据库对象
+ (FMDatabase *)database {
    NSString *path = [NCPDocumentPath() stringByAppendingString:NCPConfigString(@"SQLiteFile")];
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
+ (BOOL)insertComplainForm:(NCPComplainForm *)form {

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
                "date TEXT,"
                "average_intensity REAL,"
                "intensities TEXT,"
                "coord TEXT,"
                "auto_address TEXT,"
                "auto_latitude REAL,"
                "auto_longitude REAL,"
                "manual_address TEXT,"
                "manual_latitude REAL,"
                "manual_longitude REAL,"
                "sfa_type INTEGER,"
                "noise_type INTEGER,"
                "comment TEXT"
                ")"];
    }

    // 插入新投诉表单
    BOOL result = [db executeUpdate:@"INSERT INTO complain_form "
                                            "(form_id,"
                                            "date,"
                                            "average_intensity,"
                                            "intensities,"
                                            "coord,"
                                            "auto_address,"
                                            "auto_latitude,"
                                            "auto_longitude,"
                                            "manual_address,"
                                            "manual_latitude,"
                                            "manual_longitude,"
                                            "sfa_type,"
                                            "noise_type,"
                                            "comment) "
                                            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                                    form.formId,
                                    form.dateStorage,
                                    @(form.averageIntensity),
                                    form.intensitiesJSON,
                                    form.coord,
                                    form.autoAddress,
                                    form.autoLatitude,
                                    form.autoLongitude,
                                    form.manualAddress,
                                    form.manualLatitude,
                                    form.manualLongitude,
                                    @(form.sfaType),
                                    @(form.noiseType),
                                    form.comment
    ];

    [db close];
    return result;
}

// 查询全部投诉表单
+ (NSArray *)selectAllComplainForm {

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
        form.dateStorage = [rs stringForColumn:@"date"];

        form.intensitiesJSON = [rs stringForColumn:@"intensities"];
        if (form.intensities.count == 0) {
            [form addIntensity:[rs doubleForColumn:@"average_intensity"]];
        }

        form.coord = [rs stringForColumn:@"coord"];
        form.autoAddress = [rs stringForColumn:@"auto_address"];
        form.autoLatitude = @([rs doubleForColumn:@"auto_latitude"]);
        form.autoLongitude = @([rs doubleForColumn:@"auto_longitude"]);

        form.manualAddress = [rs stringForColumn:@"manual_address"];
        form.manualLatitude = @([rs doubleForColumn:@"manual_latitude"]);
        form.manualLongitude = @([rs doubleForColumn:@"manual_longitude"]);

        form.sfaType = (NSUInteger) [rs intForColumn:@"sfa_type"];
        form.noiseType = (NSUInteger) [rs intForColumn:@"noise_type"];
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
