//
//  NCPWebRequest.m
//  NoiseComplain
//
//  Created by mura on 12/11/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPWebRequest.h"
#import "NCPWebParameter.h"
#import "GTLBase64.h"
#import "NCPLog.h"

#pragma mark 常量定义

/*!服务器地址(包含端口号)*/
static const NSString *kNCPServerURL = @"http://localhost:8080";
/*!服务器上Web工程名称*/
static const NSString *kNCPServerProjectName = @"NCPServer";

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

- (void)addParameter:(NSString *)key withInteger:(int)value {
    NCPWebParameter *para = [NCPWebParameter parameterWithInteger:value];
    [self.paraDict setObject:para forKey:key];
}

- (void)addParameter:(NSString *)key withFloat:(float)value {
    NCPWebParameter *para = [NCPWebParameter parameterWithFloat:value];
    [self.paraDict setObject:para forKey:key];
}

- (void)addParameter:(NSString *)key withBool:(BOOL)value {
    NCPWebParameter *para = [NCPWebParameter parameterWithBool:value];
    [self.paraDict setObject:para forKey:key];
}

- (void)addParameter:(NSString *)key withString:(NSString *)value {
    NCPWebParameter *para = [NCPWebParameter parameterWithString:value];
    [self.paraDict setObject:para forKey:key];
}

- (void)addParameter:(NSString *)key withData:(NSData *)value {
    NCPWebParameter *para = [NCPWebParameter parameterWithData:value];
    [self.paraDict setObject:para forKey:key];
}

- (void)addParameterArray:(NSString *)key {
    NCPWebParameter *para = [NCPWebParameter array];
    [self.paraDict setObject:para forKey:key];
}

- (void)addToArray:(NSString *)key withInteger:(int)value {
    NCPWebParameter *array = [self.paraDict objectForKey:key];
    if (array && array.type == NCPWebArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter parameterWithInteger:value];
        [content addObject:item];
    }
}

- (void)addToArray:(NSString *)key withFloat:(float)value {
    NCPWebParameter *array = [self.paraDict objectForKey:key];
    if (array && array.type == NCPWebArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter parameterWithFloat:value];
        [content addObject:item];
    }
}

- (void)addToArray:(NSString *)key withBool:(BOOL)value {
    NCPWebParameter *array = [self.paraDict objectForKey:key];
    if (array && array.type == NCPWebArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter parameterWithBool:value];
        [content addObject:item];
    }
}

- (void)addToArray:(NSString *)key withString:(NSString *)value {
    NCPWebParameter *array = [self.paraDict objectForKey:key];
    if (array && array.type == NCPWebArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter parameterWithString:value];
        [content addObject:item];
    }
}

- (void)addToArray:(NSString *)key withData:(NSData *)value {
    NCPWebParameter *array = [self.paraDict objectForKey:key];
    if (array && array.type == NCPWebArray) {
        NSMutableArray *content = array.content;
        NCPWebParameter *item = [NCPWebParameter parameterWithData:value];
        [content addObject:item];
    }
}

- (BOOL)containsKey:(NSString *)key {
    if ([self.paraDict objectForKey:key]) {
        return true;
    } else {
        return false;
    }
}

- (BOOL)removeKey:(NSString *)key {
    if ([self containsKey:key]) {
        [self.paraDict removeObjectForKey:key];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 发起及响应请求

- (BOOL)send {
    return [self sendWithCompletionHandler:nil];
}

- (BOOL)sendWithCompletionHandler:(void(^)(NSDictionary *json))handler {
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
                        NCPLogWarn(@"Request error occored in NSURLSession completionHandler: %@", error);
                    }
                    if (handler) {
                        NSError *jsonError;
                        handler([NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]);
                        if (jsonError) {
                            NCPLogWarn(@"JSON error occored in NSURLSession completionHandler: %@", error);
                        }
                    }
               }] resume];
    return YES;
}

#pragma mark - 组织请求参数

- (NSData *)organizeHTTPBodyData {
    NSMutableData *buff = [NSMutableData data];
    BOOL first = YES;
    for (NSString *key in [self.paraDict allKeys]) {
        NCPWebParameter *value = self.paraDict[key];
        
        // 添加'&'连接符
        if (first) {
            first = NO;
        } else {
            [buff appendData:[@"&" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // 添加当前参数的字节流
        if (value.type != NCPWebArray) {
            [buff appendData:[self organizeParameterData:value key:key]];
        } else {
            NSArray *array = value.content;
            for (NCPWebParameter *item in array) {
                // 添加'&'连接符
                if (first) {
                    first = NO;
                } else {
                    [buff appendData:[@"&" dataUsingEncoding:NSUTF8StringEncoding]];
                }
                [buff appendData:[self organizeParameterData:item key:key]];
            }
        }
    }
    
    return buff;
}

- (NSData *)organizeParameterData:(NCPWebParameter *)value key:(NSString *)key {
    
    switch (value.type) {
        case NCPWebInteger:
        case NCPWebFloat:
        case NCPWebString:
            // 数字, 字符串, 直接转码和添加
            return [[NSString stringWithFormat:@"%@=%@", key, value.content] dataUsingEncoding:NSUTF8StringEncoding];
            break;
        case NCPWebBool:
            // 布尔型, 输出true或false
            if ([((NSNumber *)value.content) boolValue]) {
                return [[NSString stringWithFormat:@"%@=true", key] dataUsingEncoding:NSUTF8StringEncoding];
            } else {
                return [[NSString stringWithFormat:@"%@=false", key] dataUsingEncoding:NSUTF8StringEncoding];
            }
            break;
        case NCPWebData:
            // 二进制型, 转码为Base64
        {
            NSMutableString *buff = [NSMutableString string];
            [buff appendFormat:@"%@=", key];
            if (value.content) {
                [buff appendString:GTLEncodeBase64(value.content)];
            } else {
                [buff appendString:@"null"];
            }
            return [buff dataUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        default:
            return nil;
    }
}

@end
