//
//  NCPCoreDataDAO.m
//  NoiseComplain
//
//  Created by mura on 12/20/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPCoreDataDAO.h"

static NSString *kNCPCoreDataModelFileName = @"NoiseComplain";

@implementation NCPCoreDataDAO

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Core Data 堆栈

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

#pragma mark - 基本操作(增删改查)

- (NSArray *)findAll {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return nil;
    }
    NCPCoreDataDAO<NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO<NCPCoreDataDAOProtocol> *)self;
    
    // 建立一个用于填充的可变数组
    NSMutableArray *array = [NSMutableArray array];
    
    // 查询全部
    NSManagedObjectContext *context = dao.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:dao.entityName
                                              inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    // 设置排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:dao.key
                                                                   ascending:dao.ascending];
    NSArray *sortDescriptors = @[sortDescriptor];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchRequest
                                               error:&error];
    
    // 向数组中转换类型并添加内容
    for (NSManagedObject *mo in listData) {
        [array addObject:[dao objectWithManaged:mo]];
    }
    
    return array;
}

- (NSArray *)findByPredicate:(NSString *)format, ... {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return nil;
    }
    NCPCoreDataDAO<NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO<NCPCoreDataDAOProtocol> *)self;
    
    // 建立一个用于填充的可变数组
    NSMutableArray *array = [NSMutableArray array];
    
    // 进行有条件查询
    NSManagedObjectContext *context = dao.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:dao.entityName
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
                         fetchRequest error:&error];
    
    // 填充数组内容
    for (NSManagedObject *mo in listData) {
        [array addObject:[dao objectWithManaged:mo]];
    }
    
    return array;
}

- (id)findByKey:(id)key {
    // 获取实现了协议的self引用
    if (![self conformsToProtocol:@protocol(NCPCoreDataDAOProtocol)]) {
        return nil;
    }
    NCPCoreDataDAO<NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO<NCPCoreDataDAOProtocol> *)self;
    
    // 设置查询条件进行查询
    NSArray *array = [dao findByPredicate:@"%@ = %@", dao.key, key];
    
    if (array.count > 0) {
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
    NCPCoreDataDAO<NCPCoreDataDAOProtocol> *dao = (NCPCoreDataDAO<NCPCoreDataDAOProtocol> *)self;
    
    
    
    return NO;
}

- (BOOL)remove:(id)model {
    return NO;
}

- (BOOL)modify:(id)model {
    return NO;
}

- (BOOL)ascending {
    return YES;
}

@end
