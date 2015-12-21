//
//  NCPComplainFormDAO.h
//  NoiseComplain
//
//  Created by mura on 12/20/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPCoreDataDAO.h"

@class NCPComplainForm;

@interface NCPComplainFormDAO : NCPCoreDataDAO

/*!
 *  无条件查询: 查询所有对象
 *
 *  @return 对象可变数组
 */
- (NSMutableArray *)findAll;

/*!
 *  插入一个投诉表单对象
 *
 *  @param form 投诉表单对象
 *
 *  @return 操作是否成功
 */
- (BOOL)create:(NCPComplainForm *)form;

/*!
 *  删除一个投诉表单对象
 *
 *  @param form 投诉表单对象
 *
 *  @return 操作是否成功
 */
- (BOOL)remove:(NCPComplainForm *)form;

@end
