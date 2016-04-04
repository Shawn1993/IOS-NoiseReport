//
//  NCPWebService.h
//  NoiseComplain
//
//  Created by mura on 3/26/16.
//  Copyright © 2016 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCPComplainForm;

@interface NCPWebService : NSObject

// 向服务器发送投诉表单
+ (void)sendComplainForm:(NCPComplainForm *)form
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSString *))failure;

@end
