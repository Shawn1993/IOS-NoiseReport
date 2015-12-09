//
//  NCPNoiseMeter.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseMeter.h"
#import <AVFoundation/AVFoundation.h>

static const int kDataArrayMaxLength = 100;
static const double kTimerTickPerSecond = 30.0;

#pragma mark - NCPNoiseMeter私有分类


@interface NCPNoiseMeter () {
    
    /** 平均值记录数组 */
    NSMutableArray *_avgArray;
    /** 峰值记录数组 */
    NSMutableArray *_peakArray;
    
    /** 录音器 */
    AVAudioRecorder *_recorder;
    /** 定时器 */
    NSTimer *_timer;
    
    /** 是否暂停标识位 */
    BOOL _isPausing;
    
    /** 定时器回调Block */
    void(^_timerCallback)(void);
}


/** 定时器回调方法 */
- (void)timerCallBack:(NSTimer *)timer;

@end

@implementation NCPNoiseMeter

#pragma mark - 单例模式


/** 获取NCPNoiseMeter的单例实例 */
+ (NCPNoiseMeter *)getInstance {
    static NCPNoiseMeter *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[NCPNoiseMeter alloc] init];
    });
    return instance;
}

#pragma mark - 定时检测功能

/** (重写)init方法, 执行初始化工作并准备开始进行检测 */
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置并实例化AVAudioRecorder
        NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
        NSDictionary *settings = @{AVSampleRateKey: @44100.0,
                                     AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatAppleLossless],
                             AVNumberOfChannelsKey: @1,
                          AVEncoderAudioQualityKey: [NSNumber numberWithInt:AVAudioQualityMax]};
        _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                                settings:settings
                                                   error:nil];
        
        // 对录音器进行初始化
        if (_recorder) {
            [_recorder prepareToRecord];
            _recorder.meteringEnabled = YES;
        }
        
        // 实例化其他成员变量
        _avgArray = [[NSMutableArray alloc] init];
        _peakArray  = [[NSMutableArray alloc] init];
    }
    return self;
}

/** 开始检测并记录数据: 检测频率(每秒) */
- (void)startWithCallback:(void(^)(void))callback {
    if (_recorder) {
        
        // 初始化数据和标识位
        [_avgArray removeAllObjects];
        [_peakArray removeAllObjects];
        _isPausing = NO;
        
        // 开启录音器
        [_recorder record];
        
        // 开启定时器, 注册回调Block
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / kTimerTickPerSecond
                                                  target:self
                                                selector:@selector(timerCallBack:)
                                                userInfo:nil
                                                 repeats:YES];
        _timerCallback = callback;
    }
}

/** 暂停记录数据 */
- (void)pause {
    _isPausing = YES;
    [_recorder pause];
}

/** 继续记录数据 */
- (void)resume {
    _isPausing = NO;
    [_recorder record];
}

/** 停止记录数据 */
- (void)stop {
    if (_recorder) {
        [_recorder stop];
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _timerCallback = nil;
    }
}

/** 计时器回调方法 */
- (void)timerCallBack:(NSTimer *)timer {
    // 当没有暂停的时候才进行处理
    if (!_isPausing) {
        
        // 刷新录音器
        [_recorder updateMeters];
        
        // 记录数据
        _lastAvg = [_recorder averagePowerForChannel:0];
        _lastPeak = [_recorder peakPowerForChannel:0];
        if (_avgArray.count > kDataArrayMaxLength) {
            [_avgArray removeObjectAtIndex:0];
        }
        if (_peakArray.count > kDataArrayMaxLength) {
            [_peakArray removeObjectAtIndex:0];
        }
        [_avgArray addObject:[NSNumber numberWithDouble:_lastAvg]];
        [_peakArray addObject:[NSNumber numberWithDouble:_lastPeak]];
        
        // 调用注册的Block
        if (_timerCallback) {
            _timerCallback();
        }
    }
}

#pragma mark - 获取数据

@end
