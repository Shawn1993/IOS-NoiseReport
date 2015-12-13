//
//  NCPWebRequest.m
//  NoiseComplain
//
//  Created by mura on 12/11/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPWebRequest.h"

@interface NCPWebRequest ()

@end

@implementation NCPWebRequest

+ (NSDictionary *)connectWithPage:(NSString *)page completionHandler:(void(^)(NSDictionary *data)) handler {
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@", kNCPServerURL, kNCPServerProjectName, page];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=fuck&aaa=bbb&aaa=ccc" dataUsingEncoding:NSUTF8StringEncoding];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
                                         if (!data || error) {
                                             
                                         }
                                     }] resume];
    return nil;
}

@end
