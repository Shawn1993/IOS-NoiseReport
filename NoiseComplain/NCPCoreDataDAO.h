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

/*!Core Data DAO 基类*/
@interface NCPCoreDataDAO : NSObject

#pragma mark - CoreData

/*!被管理对象上下文*/
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
/*!被管理对象模型*/
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
/*!持久化存储协调器*/
@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!获取应用程序沙箱目录*/
- (NSURL *)applicationDocumentsDirectory;

/*!工厂方法*/
+ (instancetype)dao;

#pragma mark - 基本操作(增删改查)

/*!获取所有与此DAO相关的实体*/
- (NSArray *)findAll;

/*!根据指定的查询条件查询实体*/
- (NSArray *)findByPredicate:(NSString *)format, ...;

/*!根据主键查询实体*/
- (id)findByKey:(id)key;

/*!创建一个新的实体*/
- (BOOL)create:(id)model;

/*!删除一个实体*/
- (BOOL)remove:(id)model;

/*!修改一个实体*/
- (BOOL)modify:(id)model;

@end
