//
//  NCPNoiseMeter.m
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseMeter.h"
#import "NCPLog.h"
#import <AVFoundation/AVFoundation.h>

/** 采样率 */
#define SAMPLE_RATE 44110

/** 声道数 */
#define CHANNEL_NUM 1

/** 位数 */
#define BIT_DEPTH 8

/** 文件格式 */
#define FORMAT_ID kAudioFormatAppleLossless


static const int kDataArrayMaxLength = 100;
static const double kTimerTickPerSecond = 20;

#pragma mark - NCPNoiseMeter私有分类


@interface NCPNoiseMeter (){
    
    /** 平均值记录数组 */
    NSMutableArray *avgArray;
    /** 峰值记录数组 */
    NSMutableArray *peakArray;
    
    /** 录音器 */
    AVAudioRecorder *mAudioRecorder;
    /** 定时器 */
    NSTimer *mTimer;
    
    /** 是否暂停标识位 */
    BOOL isPaused;
    
    /** 定时器回调Block */
    void(^timerCallback)(void);
}

/** 定时器回调方法 */
- (void)timerAction:(NSTimer *)timer;

@end

@implementation NCPNoiseMeter

#pragma mark - 初始化
/** (重写)init方法, 执行初始化工作并准备开始进行检测 */
- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化录音对象
        if (!mAudioRecorder) {
            NSError *error = nil ;
            mAudioRecorder = [[AVAudioRecorder alloc] initWithURL:[self filePath] settings:[self audioSettings] error:&error];
            mAudioRecorder.meteringEnabled = YES;
            if(error){
                NCPLogVerbose(@"Error when recorder inits,%@",error.localizedDescription);
            }
            if(![mAudioRecorder prepareToRecord]){
                NCPLogVerbose(@"Error when recorder prepare", nil);
            }
        }
        // 实例化其他成员变量
        avgArray = [[NSMutableArray alloc] init];
        peakArray  = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - 获取配置的方法
/** 获得实例－文件存储路径*/
-(NSURL*)filePath
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    return url;
}

/** 获得实例－音频设定*/
- (NSDictionary*)audioSettings
{
    NSDictionary *settings = @{
                               AVFormatIDKey: [NSNumber numberWithInt:FORMAT_ID],
                               AVSampleRateKey: [NSNumber numberWithInt:SAMPLE_RATE],
                               AVNumberOfChannelsKey: [NSNumber numberWithInt:CHANNEL_NUM],
                               };
    return settings;
}

/** 获得实例－定时器*/
-(NSTimer*) timer
{
    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:1.0/kTimerTickPerSecond
                                                       target:self
                                                     selector:@selector(timerAction:)
                                                     userInfo:nil
                                                      repeats:YES];
    return  timer;
}


#pragma mark - 回调方法
/** 计时器回调方法 */
- (void)timerAction:(NSTimer *)timer {
    
    if (isPaused)
        return;
    
    // 刷新录音器
    [mAudioRecorder updateMeters];
    
    // 取值
    _lastAvg = [mAudioRecorder averagePowerForChannel:0];
    _lastPeak = [mAudioRecorder peakPowerForChannel:0];
    
    // 存值
    if (avgArray.count > kDataArrayMaxLength) {
        [avgArray removeObjectAtIndex:0];
    }
    if (peakArray.count > kDataArrayMaxLength) {
        [peakArray removeObjectAtIndex:0];
    }
    
    [avgArray addObject:[NSNumber numberWithDouble:_lastAvg]];
    [peakArray addObject:[NSNumber numberWithDouble:_lastPeak]];
    
    // 触发接口
    if (timerCallback) {
        timerCallback();
    }
}

#pragma mark - 生命周期
/** 开始检测并记录数据: 检测频率(每秒) */
- (void)startWithCallback:(void(^)(void))callback {
    
    if (!mAudioRecorder)
        return;
    if(mAudioRecorder.isRecording)
        return;
    
    // 做一些初始化
    isPaused = NO;
    timerCallback = callback;
    [avgArray removeAllObjects];
    [peakArray removeAllObjects];
    
    // 开始录音
    [mAudioRecorder record];
    
    // 开启定时器
    mTimer = [self timer];
    
    [mTimer fire];
}


/** 暂停记录数据 */
- (void)pause {
    if (!mAudioRecorder)
        return;
    if(isPaused)
        return;
    [mAudioRecorder pause];
    isPaused = YES;
}

/** 继续记录数据 */
- (void)resume {
    if (!mAudioRecorder)
        return;
    if(!isPaused)
        return;
    [mAudioRecorder record];
    isPaused = NO;
}

/** 停止记录数据 */
- (void)stop {
    if (!mAudioRecorder)
        return;
    if (mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
        timerCallback = nil;
    }
    [mAudioRecorder stop];
    mAudioRecorder = nil;
    isPaused = YES;
}

@end
