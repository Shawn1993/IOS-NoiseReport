//
//  NCPCoreDataDAOProtocol.h
//  NoiseComplain
//
//  Created by mura on 12/21/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#ifndef NCPCoreDataDAOProtocol_h
#define NCPCoreDataDAOProtocol_h

/*!DAO相关协议, 提供实体相关的信息*/
@protocol NCPCoreDataDAOProtocol <NSObject>

@required

/*!
 *  获取DAO对应实体的名称<br>
 *  实体名称应当与<b>.xcdatamodeld</b>文件中的实体名称一致
 *
 *  @return 对应实体的名称
 */
- (NSString *)entityName;

/*!
 *  通过ManagedObject获取对应Object转换方法
 *
 *  @param mo 被托管模型对象
 *
 *  @return 对应Object
 */
- (id)objectWithManagedObject:(NSManagedObject *)mo;

/*!
 *  通过Object为ManagedObject的各属性赋值
 *
 *  @param obj 模型对象
 *  @param mo  被托管模型对象
 *
 *  @return 被托管模型对象
 */
- (NSManagedObject *)assignWithObject:(id)model managedObject:(NSManagedObject *)mo;

/*!
 *  主键名, 是排序和查找的依据
 *
 *  @return 字段名
 */
- (NSString *)keyName;

/*!
 *  从模型对象中获取主键的值
 *
 *  @param model 模型队形
 *
 *  @return 主键的值
 */
- (id)keyValueWithObject:(id)model;

@end

/* 方法实现部分, 可直接拷贝使用

- (NSString *)entityName {
    
}

- (id)objectWithManagedObject:(NSManagedObject *)mo {
    
}

- (NSManagedObject *)assignWithObject:(id)model managedObject:(NSManagedObject *)mo {
    
}

- (NSString *)keyName {
    
}

- (id)keyValueWithObject:(id)model {
    
}
 
*/

#endif /* NCPCoreDataDAOProtocol_h */
