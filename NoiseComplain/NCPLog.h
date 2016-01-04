//
//  NCPLog.h
//  NoiseComplain
//
//  Created by mura on 12/31/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#ifndef NCPLog_h
#define NCPLog_h

/*!
 *  使用以下的宏定义代替NSLog<br>
 *  <b>优点!!!</b><br>
 *  可以方便地全局开关日志功能(关闭时不产生任何代码, 只有空语句)<br>
 *  可以自定义格式, 配合<b>LSLog-Xcode</b>等插件使用, 可以过滤且非常清晰<br>
 *  可以明显地与其他第三方库和系统产生的日志作区分
 */

#include <Foundation/Foundation.h>

/*!
 *  开启/关闭日志功能标识位<br>
 *  开启日志功能时赋值为<b>1</b><br>
 *  关闭日志功能时赋值为<b>0</b>
 */
#define _NCPLOG_ON 1

#pragma mark - 开启Log功能

#if _NCPLOG_ON

/*!
 *  发送一条Verbose日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogVerbose(format, ...)  NSLog([NSString stringWithFormat:@"<V> %@", format], __VA_ARGS__)

/*!
 *  发送一条Info日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogInfo(format, ...)     NSLog([NSString stringWithFormat:@"<I> %@", format], __VA_ARGS__)

/*!
 *  发送一条Warn日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogWarn(format, ...)     NSLog([NSString stringWithFormat:@"<W> %@", format], __VA_ARGS__)

/*!
 *  发送一条Error日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogError(format, ...)    NSLog([NSString stringWithFormat:@"<E> %@", format], __VA_ARGS__)

/*!
 *  发送一条日志(默认Verbose)
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLog(format, ...)         NCPLogVerbose(format, __VA_ARGS__)

#pragma mark - 关闭Log功能

#else

/*!
 *  发送一条Verbose日志(已在NCPLog.h中禁用)
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogVerbose(format, ...)

/*!
 *  发送一条Info日志(已在NCPLog.h中禁用)
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogInfo(format, ...)

/*!
 *  发送一条Warn日志(已在NCPLog.h中禁用)
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogWarn(format, ...)

/*!
 *  发送一条Error日志(已在NCPLog.h中禁用)
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogError(format, ...)

/*!
 *  发送一条默认类型日志(已在NCPLog.h中禁用)
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLog(format, ...)

#endif /* _NCPLOG_ON */

#undef _NCPLOG_ON

#endif /* NCPLog_h */
