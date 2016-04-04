//
//  NCPNoiseRecorder.m
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseRecorder.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - 配置信息获取

// 获取最大值
static double max() {
    static double max;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        max = NCPConfigDouble(@"RecorderMaxValue");
    });
    return max;
}

// 获取最大值
static double min() {
    static double min;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        min = NCPConfigDouble(@"RecorderMinValue");
    });
    return min;
}

@interface NCPNoiseRecorder ()

// 录音器对象(系统接口)
@property(nonatomic, strong) AVAudioRecorder *audioRecorder;

// 声强
@property(nonatomic, readonly) double currentValue;
@property(nonatomic, readonly) double peakValue;

#pragma mark - 定期调用属性
@property(nonatomic, assign) NSTimeInterval tick;
@property(nonatomic, strong) NSTimer *ticker;
@property(nonatomic, strong) void (^tickHandler)(double current, double peak);

#pragma mark - 定时结束属性
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, strong) void (^timeupHandler)(double current, double peak);

@end

@implementation NCPNoiseRecorder

#pragma mark - 录音器初始化

// 初始化录音器对象, 准备开始录音
- (void)initAVAudioRecorder {
    if (!self.audioRecorder) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        NSDictionary *settings = @{
                AVFormatIDKey : @(kAudioFormatAppleLossless),
                AVSampleRateKey : @(NCPConfigInteger(@"RecorderSampleRate")),
                AVNumberOfChannelsKey : @(NCPConfigInteger(@"RecorderChannelNum")),
        };
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"/dev/null"]
                                                         settings:settings
                                                            error:nil];
        self.audioRecorder.meteringEnabled = YES;
    }
}

#pragma mark - 声强计算

// 获取平均值
- (double)currentValue {
    static double last = 0.0f;
    double current = (([self.audioRecorder averagePowerForChannel:0] + 160) * (max() - min()) / 160) + min();
    double average = (current + last) / 2.0;
    last = current;
    return average;
}

// 获取峰值
- (double)peakValue {
    return (([self.audioRecorder peakPowerForChannel:0] + 160) * (max() - min()) / 160) + min();
}

#pragma mark - 开启与停止

- (void)start {
    // 初始化录音器
    [self initAVAudioRecorder];

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

    _isRecording = YES;
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

    _isRecording = false;
}

- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(double current, double peak))handler {
    self.duration = duration;
    self.timeupHandler = handler;
    [self start];
}

- (void)startWithTick:(NSTimeInterval)tick
          tickHandler:(void (^)(double current, double peak))handler {
    self.tick = tick;
    self.tickHandler = handler;
    [self start];
}

- (void)startWithDuration:(NSTimeInterval)duration
            timeupHandler:(void (^)(double current, double peak))timeupHandler
                     tick:(NSTimeInterval)tick
              tickHandler:(void (^)(double current, double peak))tickHandler {
    self.duration = duration;
    self.timeupHandler = timeupHandler;
    self.tick = tick;
    self.tickHandler = tickHandler;
    [self start];
}

#pragma mark - 计时器回调

- (void)tickCallBack {
    // 刷新录音器
    [self.audioRecorder updateMeters];
    self.tickHandler(self.currentValue, self.peakValue);
}

- (void)timeupCallBack {
    [self.audioRecorder updateMeters];
    self.timeupHandler(self.currentValue, self.peakValue);
    [self stop];
}

@end
