//
//  NCPCoreDataDAOProtocol.h
//  NoiseComplain
//
//  Created by mura on 12/21/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#ifndef NCPCoreDataDAOProtocol_h
#define NCPCoreDataDAOProtocol_h

/*!
 *  DAO相关协议
 *  <p>
 *  为了方便地实现各种DAO, 规定的一些方法, 提供实体相关的信息
 */
@protocol NCPCoreDataDAOProtocol <NSObject>

@required

/*!
 *  获取DAO对应实体的名称, 用于获取实体
 *
 *  @return 对应实体的名称
 */
- (NSString *)entityName;

/*!
 *  通过ManagedObject获取对应Object转换方法
 *
 *  @param mo ManagedObjcet
 *
 *  @return 对应Object
 */
- (id)objectWithManaged:(NSManagedObject *)mo;

/*!
 *  通过Object获取对应ManagedObjcet转换方法
 *
 *  @param obj Object
 *
 *  @return 对应ManagedObject
 */
- (NSManagedObject *)managedWithObject:(id)obj;

/*!
 *  主键名, 是排序和查找的依据
 *
 *  @return 字段名
 */
- (NSString *)key;

@optional

/*!
 *  主键排序方向<br>
 *  默认升序(如果没有实现这个方法的话)
 *
 *  @return 升序返回<b>YES</b>, 降序返回<b>NO</b>
 */
- (BOOL)ascending;

@end

#endif /* NCPCoreDataDAOProtocol_h */
