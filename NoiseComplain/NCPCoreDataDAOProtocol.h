//
//  NCPCoreDataDAOProtocol.h
//  NoiseComplain
//
//  Created by mura on 12/21/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#ifndef NCPCoreDataDAOProtocol_h
#define NCPCoreDataDAOProtocol_h

/**
 * DAO协议, 提供实体相关的信息, 使用模版DAO实现功能
 */
@protocol NCPCoreDataDAOProtocol <NSObject>

@required

/**
 *  获取DAO对应实体的名称<br>
 *  实体名称应当与<b>.xcdatamodeld</b>文件中的实体名称一致
 *
 *  @return 对应实体的名称
 */
- (NSString *)entityName;

/**
 *  通过ManagedObject获取对应Object转换方法
 *
 *  @param mo 被托管模型对象
 *
 *  @return 对应Object
 */
- (id)objectWithManagedObject:(NSManagedObject *)mo;

/**
 *  通过Object为ManagedObject的各属性赋值
 *
 *  @param obj 模型对象
 *  @param mo  被托管模型对象
 *
 *  @return 被托管模型对象
 */
- (NSManagedObject *)assignWithObject:(id)model managedObject:(NSManagedObject *)mo;

/**
 *  获取模型对象主键的名字(用于排序)
 *
 *  @return 主键名字
 */
- (NSString *)keyName;

/**
 *  查询条件格式字符串
 *
 *  @return 查询条件字符串
 */
- (NSString *)predicate;

/**
 *  从模型对象中获取主键的值
 *
 *  @param model 模型队形
 *
 *  @return 主键的值
 */
- (id)keyValue:(id)model;

@end

#endif /* NCPCoreDataDAOProtocol_h */
