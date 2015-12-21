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

@end
