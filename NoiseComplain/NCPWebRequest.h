//
//  NCPWebRequest.h
//  NoiseComplain
//
//  Created by mura on 12/11/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *kNCPServerURL = @"http://10.10.10.99:8080";
static const NSString *kNCPServerProjectName = @"NoiseComplainServer";

/** 网络请求类: 与服务器进行通信 */
@interface NCPWebRequest : NSObject

- (instancetype)initWithPage:(NSString *)page;

- (void)addKey:(NSString *)key value:(id)value;

+ (NSDictionary *)connectWithPage:(NSString *)page completionHandler:(void(^)(NSDictionary *data)) handler;

@end
