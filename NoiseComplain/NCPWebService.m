//
//  NCPWebService.m
//  NoiseComplain
//
//  Created by mura on 3/26/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import "NCPWebService.h"
#import "NCPComplainForm.h"
#import "AFNetworking.h"

#pragma mark - 常量定义

static NSString *kNCPServerHost = @"http://localhost:8080";

@implementation NCPWebService

#pragma mark - 投诉请求

+ (void)sendComplainForm:(NCPComplainForm *)form
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSError *))failure; {

    // 组织参数
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setValue:form.devId forKey:@"devId"];
    [paras setValue:form.comment forKey:@"comment"];
    [paras setValue:NCPStringFormDate(form.date) forKey:@"date"];
    [paras setValue:form.intensity forKey:@"intensity"];
    [paras setValue:form.address forKey:@"address"];
    [paras setValue:form.latitude forKey:@"latitude"];
    [paras setValue:form.longitude forKey:@"longitude"];
    [paras setValue:form.coord forKey:@"coord"];
    [paras setValue:form.sfaType forKey:@"sfaType"];
    [paras setValue:form.noiseType forKey:@"noiseType"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[kNCPServerHost stringByAppendingString:@"/complain"]
       parameters:paras
         progress:nil
          success:^(NSURLSessionDataTask *task, id resp) {
              // 请求成功, 解析JSON字符串, 进行处理
              NSError *error;
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *) resp options:0 error:&error];
              if (error) {
                  failure(error);
              } else {
                  // 成功请求并解析返回的字符串
                  success(json);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              // 请求失败, 返回错误消息
              failure(error);
          }];
}

@end
