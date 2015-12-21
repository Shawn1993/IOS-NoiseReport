//
//  NCPCoreDataDAO.h
//  NoiseComplain
//
//  Created by mura on 12/20/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

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

@end
