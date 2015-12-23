//
//  NCPWebRequest.m
//  NoiseComplain
//
//  Created by mura on 12/11/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPWebRequest.h"
#import "NCPWebParameter.h"

#pragma mark 常量定义

/*!
 *  服务器地址(包含端口号)
 */
static const NSString *kNCPServerURL = @"http://localhost:8080";

/*!
 *  服务器上Web工程名称
 */
static const NSString *kNCPServerProjectName = @"NoiseComplainServer";

#pragma mark - 私有分类

@interface NCPWebRequest ()

- (NSData *)organizeHTTPBodyData;
- (NSData *)organizeParameterData:(NCPWebParameter *)para key:(NSString *)key;

@end

@implementation NCPWebRequest

#pragma mark - 获取实例

+ (instancetype)requestWithPage:(NSString *)page {
    return [[NCPWebRequest alloc] initWithPage:page];
}

- (instancetype)initWithPage:(NSString *)page {
    self = [super init];
    if (self) {
        _page = page;
        _paraDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 设置参数

- (void)setKey:(NSString *)key forInteger:(int)value {
    NCPWebParameter *para = [NCPWebParameter paraWithInteger:value];
    [_paraDict setObject:para forKey:key];
}

- (void)setKey:(NSString *)key forFloat:(float)value {
    NCPWebParameter *para = [NCPWebParameter paraWithFloat:value];
    [_paraDict setObject:para forKey:key];
}

- (void)setKey:(NSString *)key forBool:(BOOL)value {
    NCPWebParameter *para = [NCPWebParameter paraWithBool:value];
    [_paraDict setObject:para forKey:key];
}

- (void)setKey:(NSString *)key forString:(NSString *)value {
    NCPWebParameter *para = [NCPWebParameter paraWithString:value];
    [_paraDict setObject:para forKey:key];
}

- (void)setKey:(NSString *)key forData:(NSData *)value {
    NCPWebParameter *para = [NCPWebParameter paraWithData:value];
    [_paraDict setObject:para forKey:key];
}

- (void)setEmptyArrayWithKey:(NSString *)key type:(NCPWebParaTypeEnum)type{
    if ([NCPWebParameter isArray:type]) {
        NCPWebParameter *para = [NCPWebParameter arrayWithType:type];
        [_paraDict setObject:para forKey:key];
    }
}

- (void)addInteger:(int)value toArray:(NSString *)key {
    NCPWebParameter *array = [_paraDict objectForKey:key];
    if (array && array.type == NCPWebIntegerArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter paraWithInteger:value];
        [content addObject:item];
    }
}

- (void)addFloat:(float)value toArray:(NSString *)key {
    NCPWebParameter *array = [_paraDict objectForKey:key];
    if (array && array.type == NCPWebFloatArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter paraWithFloat:value];
        [content addObject:item];
    }
}

- (void)addBool:(BOOL)value toArray:(NSString *)key {
    NCPWebParameter *array = [_paraDict objectForKey:key];
    if (array && array.type == NCPWebBoolArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter paraWithBool:value];
        [content addObject:item];
    }
}

- (void)addString:(NSString *)value toArray:(NSString *)key {
    NCPWebParameter *array = [_paraDict objectForKey:key];
    if (array && array.type == NCPWebStringArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter paraWithString:value];
        [content addObject:item];
    }
}

- (void)addData:(NSData *)value toArray:(NSString *)key {
    NCPWebParameter *array = [_paraDict objectForKey:key];
    if (array && array.type == NCPWebDataArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter paraWithData:value];
        [content addObject:item];
    }
}

- (BOOL)containsKey:(NSString *)key {
    if ([_paraDict objectForKey:key]) {
        return true;
    } else {
        return false;
    }
}

- (BOOL)removeKey:(NSString *)key {
    if ([self containsKey:key]) {
        [_paraDict removeObjectForKey:key];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 发起及响应请求

- (BOOL)send {
    return [self sendWithCompletionHandler:nil];
}

- (BOOL)sendWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSDictionary *object))handler {
    // 检查page是否有效
    if (!_page) {
        // page没有被正确地赋值, 请求无法发出
        return NO;
    }
    
    // 使用NSURLSession类进行网络连接
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@", kNCPServerURL, kNCPServerProjectName, _page];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 使用POST请求
    request.HTTPMethod = @"POST";
    
    // 添加参数
    request.HTTPBody = [self organizeHTTPBodyData];
    
    // 发送请求
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    }
                    if (handler) {
                        NSError *jsonError;
                        handler(data, response, [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]);
                        if (jsonError) {
                            NSLog(@"JSON Error: %@", jsonError);
                        }
                    }
               }] resume];
    return YES;
}

#pragma mark - 组织请求参数

- (NSData *)organizeHTTPBodyData {
    NSMutableData *buff = [NSMutableData data];
    BOOL first = YES;
    for (NSString *key in [_paraDict allKeys]) {
        NCPWebParameter *value = _paraDict[key];
        
        // 添加'&'连接符
        if (first) {
            first = NO;
        } else {
            [buff appendData:[@"&" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // 添加当前参数的字节流
        [buff appendData:[self organizeParameterData:value key:key]];
    }
    
    return buff;
}

- (NSData *)organizeParameterData:(NCPWebParameter *)value key:(NSString *)key {
    
    // 获取前缀
    NSString *prefix = [value prefix];
    
    switch (value.type) {
        case NCPWebInteger:
        case NCPWebFloat:
        case NCPWebString:
            // 数字, 字符串, 直接转码和添加
            return [[NSString stringWithFormat:@"%@%@=%@", prefix, key, value.content] dataUsingEncoding:NSUTF8StringEncoding];
            break;
        case NCPWebBool:
            // 布尔型, 输出true或false
            if ([((NSNumber *)value.content) boolValue]) {
                return [[NSString stringWithFormat:@"%@%@=true", prefix, key] dataUsingEncoding:NSUTF8StringEncoding];
            } else {
                return [[NSString stringWithFormat:@"%@%@=false", prefix, key] dataUsingEncoding:NSUTF8StringEncoding];
            }
            break;
        case NCPWebData:
            // 二进制型, 不转码直接附加
        {
            NSMutableData *buff = [NSMutableData data];
            [buff appendData:[[NSString stringWithFormat:@"%@%@=", prefix, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [buff appendData:value.content];
            return buff;
        }
            break;
        case NCPWebIntegerArray:
        case NCPWebFloatArray:
        case NCPWebStringArray:
            // 数字, 字符串数组型
        {
            NSMutableString *buff = [NSMutableString string];
            NSArray *array = value.content;
            for (NCPWebParameter *item in array) {
                [buff appendFormat:@"%@%@=%@", prefix, key, item.content];
            }
            return [buff dataUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case NCPWebBoolArray:
            // 布尔型数组型
        {
            NSMutableString *buff = [NSMutableString string];
            NSArray *array = value.content;
            for (NCPWebParameter *item in array) {
                if ([((NSNumber *)item.content) boolValue]) {
                    [buff appendFormat:@"%@%@=true", prefix, key];
                } else {
                    [buff appendFormat:@"%@%@=false", prefix, key];
                }
            }
            return [buff dataUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case NCPWebDataArray:
        {
            NSMutableData *buff = [NSMutableData data];
            NSArray *array = value.content;
            for (NCPWebParameter *item in array) {
                [buff appendData:[[NSString stringWithFormat:@"%@%@=", prefix, key] dataUsingEncoding:NSUTF8StringEncoding]];
                [buff appendData:item.content];
            }
            return buff;
        }
            break;
        default:
            return nil;
    }
}

@end
