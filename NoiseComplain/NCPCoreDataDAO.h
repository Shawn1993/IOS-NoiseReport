//
//  NCPCoreDataDAO.h
//  NoiseComplain
//
//  Created by mura on 12/20/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NCPCoreDataDAOProtocol.h"

/*!
 *  Core Data DAO 基类
 */
@interface NCPCoreDataDAO : NSObject

#pragma mark - Core Data 堆栈

/*!
 *  被管理对象上下文
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/*!
 *  被管理对象模型
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/*!
 *  持久化存储协调器
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 *  获取应用程序沙箱目录
 *
 *  @return 沙箱目录URL
 */
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - 基本操作(增删改查)

- (NSArray *)findAll;
- (NSArray *)findByPredicate:(NSString *)format, ...;
- (id)findByKey:(id)key;
- (BOOL)create:(id)model;
- (BOOL)remove:(id)model;
- (BOOL)modify:(id)model;

- (BOOL)ascending;

@end
