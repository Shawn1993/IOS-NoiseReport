//
//  NCPNoiseRecorder.h
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCPNoiseRecorder : NSObject

- (void)start;

- (void)stop;

- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(float current, float peak))handler;

- (void)startWithTick:(NSTimeInterval)tick
          tickHandler:(void (^)(float current, float peak))handler;

- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(float current, float peak))timeupHandler
                     tick:(NSTimeInterval)tick
              tickHandler:(void (^)(float current, float peak))tickHandler;

@end
