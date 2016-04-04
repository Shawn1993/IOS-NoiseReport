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

@implementation NCPWebService

#pragma mark - 投诉请求

+ (void)sendComplainForm:(NCPComplainForm *)form
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSString *))failure; {

    // 组织参数
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setValue:form.devId forKey:@"devId"];
    [paras setValue:form.devType forKey:@"devType"];
    [paras setValue:NCPRequestFormatStringFormDate(form.date) forKey:@"date"];

    [paras setValue:@(form.averageIntensity) forKey:@"averageIntensity"];
    [paras setValue:form.intensitiesJSON forKey:@"intensities"];

    [paras setValue:form.coord forKey:@"coord"];
    [paras setValue:form.autoAddress forKey:@"autoAddress"];
    [paras setValue:form.autoLatitude forKey:@"autoLatitude"];
    [paras setValue:form.autoLongitude forKey:@"autoLongitude"];
    [paras setValue:form.autoAltitude forKey:@"autoAltitude"];
    [paras setValue:form.autoHorizontalAccuracy forKey:@"autoHorizontalAccuracy"];
    [paras setValue:form.autoVerticalAccuracy forKey:@"autoVerticalAccuracy"];

    [paras setValue:form.manualAddress forKey:@"manualAddress"];
    [paras setValue:form.manualLatitude forKey:@"manualLatitude"];
    [paras setValue:form.manualLongitude forKey:@"manualLongitude"];

    [paras setValue:form.sfaType forKey:@"sfaType"];
    [paras setValue:form.noiseType forKey:@"noiseType"];
    [paras setValue:form.comment forKey:@"comment"];

    // 发送请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NCPConfigString(@"ServerHost") stringByAppendingString:NCPConfigString(@"ServerComplainPage")]
       parameters:paras
         progress:nil
          success:^(NSURLSessionDataTask *task, id resp) {
              NSError *error;
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *) resp options:0 error:&error];
              if (error) {
                  failure(error.localizedDescription);
              } else {
                  // 解析成功, 请求成功
                  success(json);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              // 请求失败, 返回错误消息
              NSLog(@"Failure!!!");
              NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
              if (data) {
                  NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                  NSError *jError;
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jError];
                  if (jError) {
                      failure(jError.localizedDescription);
                  } else {
                      failure(json[NCPConfigString(@"ServerErrorMessageKey")]);
                  }
              } else {
                  failure(error.localizedDescription);
              }
          }];
}

@end
