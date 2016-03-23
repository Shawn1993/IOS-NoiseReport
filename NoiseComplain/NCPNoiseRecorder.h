//
//  NCPNoiseRecorder.h
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 噪声录音机类, 封装系统接口用于获取环境声音强度
 */
@interface NCPNoiseRecorder : NSObject

// 开始录音
- (void)start;

// 结束录音
- (void)stop;

// 开始录音, 一段时间后, 结束录音并调用timeupHandler块
- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(float current, float peak))handler;

// 开始录音, 并定期调用tickHandler块
- (void)startWithTick:(NSTimeInterval)tick
          tickHandler:(void (^)(float current, float peak))handler;

// 开始录音, 定期调用tickHandler块, 一段时间后, 结束录音并调用timeupHandler块
- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(float current, float peak))timeupHandler
                     tick:(NSTimeInterval)tick
              tickHandler:(void (^)(float current, float peak))tickHandler;

@end
