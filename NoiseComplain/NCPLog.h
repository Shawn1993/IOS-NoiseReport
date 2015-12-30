//
//  NCPLog.h
//  NoiseComplain
//
//  Created by mura on 12/31/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#ifndef NCPLog_h
#define NCPLog_h

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
#define NCPLogVerbose(format, ...)  NSLog([NSString stringWithFormat:@"<VERBOSE> %@", format], __VA_ARGS__)

/*!
 *  发送一条Info日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogInfo(format, ...)     NSLog([NSString stringWithFormat:@"<INFO> %@", format], __VA_ARGS__)

/*!
 *  发送一条Warn日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogWarn(format, ...)     NSLog([NSString stringWithFormat:@"<WARN> %@", format], __VA_ARGS__)

/*!
 *  发送一条Error日志
 *
 *  @param format 格式字符串
 *  @param ...    参数(若无, 请传入<b>nil</b>)
 */
#define NCPLogError(format, ...)    NSLog([NSString stringWithFormat:@"<ERROR> %@", format], __VA_ARGS__)

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

#endif

#undef _NCPLOG_ON

#endif /* NCPLog_h */
