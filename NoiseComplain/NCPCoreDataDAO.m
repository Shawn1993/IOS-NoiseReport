//
//  NCPCoreDataDAO.m
//  NoiseComplain
//
//  Created by mura on 12/20/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPCoreDataDAO.h"
#import "NCPLog.h"

static NSString *kNCPCoreDataModelFileName = @"NoiseComplain";

static void errorLog(NSError *error) {
    if (error) {
        NCPLogWarn(@"CoreData Error: %@", error);
    }
}

@implementation NCPCoreDataDAO {
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

#pragma mark - CoreData

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        // 初始化被管理对象上下文
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        // 初始化被管理对象模型
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kNCPCoreDataModelFileName
                                                  withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        // 初始化持久化存储协调器
        NSURL *storeURL = [[self applicationDocumentsDirectory]
                URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kNCPCoreDataModelFileName]];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:nil
                                                          error:nil];
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 工厂方法

+ (instancetype)dao {
    return [[self alloc] init];
}

#pragma mark - 基本操作(增删改查)

- (NSArray *)findAll {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return nil;
    }
    NCPCoreDataDAO <NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO <NCPCoreDataDAOProtocol> *) self;

    // 建立一个用于填充的可变数组
    NSMutableArray *array = [NSMutableArray array];

    // 查询全部
    NSManagedObjectContext *context = dao.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[dao entityName]
                                              inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;

    // 设置排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[dao keyName]
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    fetchRequest.sortDescriptors = sortDescriptors;

    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchRequest
                                               error:&error];
    errorLog(error);

    // 向数组中转换类型并添加内容
    for (NSManagedObject *mo in listData) {
        [array addObject:[dao objectWithManagedObject:mo]];
    }

    return array;
}

- (NSArray *)findByPredicate:(NSString *)format, ... {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return nil;
    }
    NCPCoreDataDAO <NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO <NCPCoreDataDAOProtocol> *) self;

    // 建立一个用于填充的可变数组
    NSMutableArray *array = [NSMutableArray array];

    // 进行有条件查询
    NSManagedObjectContext *context = dao.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[dao entityName]
                                              inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;

    // 获取查询条件的可变参数
    va_list ap;
    va_start(ap, format);
    fetchRequest.predicate = [NSPredicate predicateWithFormat:format arguments:ap];
    va_end(ap);

    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:
            fetchRequest                       error:&error];
    errorLog(error);

    // 填充数组内容
    for (NSManagedObject *mo in listData) {
        [array addObject:[dao objectWithManagedObject:mo]];
    }

    return array;
}

- (id)findByKey:(id)key {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return nil;
    }
    NCPCoreDataDAO <NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO <NCPCoreDataDAOProtocol> *) self;

    // 设置查询条件进行查询
    NSArray *array = [dao findByPredicate:[dao predicate], key];

    if (array.count > 0) {
        // TODO: 如果返回多个?
        return array.lastObject;
    } else {
        return nil;
    }
}

- (BOOL)create:(id)model {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return NO;
    }
    NCPCoreDataDAO <NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO <NCPCoreDataDAOProtocol> *) self;

    NSManagedObjectContext *context = dao.managedObjectContext;

    // 在插入前检查是否已经存在此实体
    id exist = [dao findByKey:[dao keyValue:model]];
    if (exist) {
        [dao modify:model];
        return NO;
    }

    // 获取ManagedObject并为其赋值
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:[dao entityName]
                                                        inManagedObjectContext:context];
    [dao assignWithObject:model managedObject:mo];

    // 检查是否成功提交更改
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        errorLog(error);
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)remove:(id)model {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return NO;
    }
    NCPCoreDataDAO <NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO <NCPCoreDataDAOProtocol> *) self;

    NSManagedObjectContext *context = dao.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[dao entityName]
                                              inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;

    // 设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[dao predicate], [dao keyValue:model]];
    NSLog(@"%@",predicate);
    fetchRequest.predicate = predicate;

    // 提交请求, 获取要删除的实体
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchRequest error:&error];
    errorLog(error);

    if (listData.count > 0) {
        NSManagedObject *mo = listData.lastObject;
        [context deleteObject:mo];

        // 检查是否提交成功
        error = nil;
        if (context.hasChanges && ![context save:&error]) {
            errorLog(error);
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (BOOL)modify:(id)model {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return NO;
    }
    NCPCoreDataDAO <NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO <NCPCoreDataDAOProtocol> *) self;

    NSManagedObjectContext *context = dao.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[dao entityName]
                                              inManagedObjectContext:context];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;

    // 设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[dao predicate], [dao keyValue:model]];
    fetchRequest.predicate = predicate;

    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchRequest
                                               error:&error];
    errorLog(error);

    if (listData.count > 0) {
        NSManagedObject *mo = listData.lastObject;
        [dao assignWithObject:model managedObject:mo];

        error = nil;
        if (context.hasChanges && ![context save:&error]) {
            errorLog(error);
            return NO;
        } else {
            return YES;
        }
    }

    return NO;
}

@end
