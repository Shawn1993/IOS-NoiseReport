//
//  NCPNoiseRecorder.m
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseRecorder.h"
#import <AVFoundation/AVFoundation.h>

/** 采样率 */
static const int kSampleRate = 44110;
/** 声道数 */
static const int kChannelNum = 1;

// 最大值 & 最小值: 原始数值为(-160, 0), 将其缩放至新的区间中
static const float kValueMax = 115;
static const float kValueMin = -45;

@interface NCPNoiseRecorder ()

@property(nonatomic, strong) AVAudioRecorder *audioRecorder;

// Tick
@property(nonatomic, assign) NSTimeInterval tick;
@property(nonatomic, strong) NSTimer *ticker;
@property(nonatomic, strong) void (^tickHandler)(float current, float peak);

// Duration
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, strong) void (^timeupHandler)(float current, float peak);

// Power
@property(nonatomic, readonly, getter=currentPower) float currentPower;
@property(nonatomic, readonly, getter=peakPower) float peakPower;

@end

@implementation NCPNoiseRecorder

#pragma mark - 私有的方法

/** 初始化录音器*/
- (void)initAudiRecorder {
    if (!self.audioRecorder) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self filePath] settings:[self audioSettings] error:nil];
        self.audioRecorder.meteringEnabled = YES;
    }
}

/** 获得实例－文件存储路径*/
- (NSURL *)filePath {
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    return url;
}

/** 获得实例－音频设定*/
- (NSDictionary *)audioSettings {
    NSDictionary *settings = @{
            AVFormatIDKey : @(kAudioFormatAppleLossless),
            AVSampleRateKey : @(kSampleRate),
            AVNumberOfChannelsKey : @(kChannelNum),
    };
    return settings;
}

/** 获取平均值*/
- (float)currentPower {
    return (([self.audioRecorder averagePowerForChannel:0] + 160) * (kValueMax - kValueMin) / 160) + kValueMin;
}

/** 获取峰值*/
- (float)peakPower {
    return (([self.audioRecorder peakPowerForChannel:0] + 160) * (kValueMax - kValueMin) / 160) + kValueMin;
}

#pragma mark - 公开方法

- (void)start {
    // 初始化录音器
    [self initAudiRecorder];

    if (self.audioRecorder.isRecording) {
        // 如果正在录音, 返回
        return;
    }

    // 如果要Tick
    if (self.tick > 0 && self.tickHandler) {
        self.ticker = [NSTimer scheduledTimerWithTimeInterval:self.tick
                                                       target:self
                                                     selector:@selector(tickCallBack)
                                                     userInfo:nil
                                                      repeats:YES];
    }

    // 如果要定时结束
    if (self.duration > 0 && self.timeupHandler) {
        [NSTimer scheduledTimerWithTimeInterval:self.duration
                                         target:self
                                       selector:@selector(timeupCallBack)
                                       userInfo:nil
                                        repeats:NO];
    }

    // 开启录音器
    [self.audioRecorder record];
    [self.audioRecorder updateMeters];
}


- (void)stop {

    // 释放录音器
    [self.audioRecorder stop];
    self.audioRecorder = nil;

    // 释放调用的Blocks和对象
    self.tick = 0;
    [self.ticker invalidate];
    self.ticker = nil;
    self.tickHandler = nil;
    self.duration = 0;
    self.timeupHandler = nil;
}

- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(float current, float peak))handler {
    self.duration = duration;
    self.timeupHandler = handler;
    [self start];
}

- (void)startWithTick:(NSTimeInterval)tick
          tickHandler:(void (^)(float current, float peak))handler {
    self.tick = tick;
    self.tickHandler = handler;
    [self start];
}

- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(float current, float peak))timeupHandler
                     tick:(NSTimeInterval)tick
              tickHandler:(void (^)(float current, float peak))tickHandler {
    self.duration = duration;
    self.timeupHandler = timeupHandler;
    self.tick = tick;
    self.tickHandler = tickHandler;
    [self start];
}

#pragma mark - 计时器回调方法

- (void)tickCallBack {
    [self.audioRecorder updateMeters];
    self.tickHandler(self.currentPower, self.peakPower);
}

- (void)timeupCallBack {
    [self.audioRecorder updateMeters];
    self.timeupHandler(self.currentPower, self.peakPower);
    [self stop];
}

@end
