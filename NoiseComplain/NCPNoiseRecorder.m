//
//  NCPNoiseRecorder.m
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseRecorder.h"
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

@interface  NCPNoiseRecorder(){
    AVAudioRecorder *mAudioRecorder;
}

- (NSDictionary*)audioSettings;
-(NSURL*)filePath;

@end

@implementation NCPNoiseRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
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
    }
    return self;
}

#pragma mark - 获取配置的方法
/** 获得实例－文件存储路径*/
- (NSURL*)filePath
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

- (void)start{
    if(!mAudioRecorder)
        return;
    if(mAudioRecorder.isRecording)
        return;
    [mAudioRecorder record];
    [mAudioRecorder updateMeters];
}

- (void)finish{
    [mAudioRecorder stop];
    mAudioRecorder = nil;
}

- (void)finishUsingBlock:(NCPRecorderBlock)block{
    [mAudioRecorder updateMeters];
    block([mAudioRecorder averagePowerForChannel:0],
          [mAudioRecorder peakPowerForChannel:0]);
    [self finish];
}

@end
