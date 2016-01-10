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

@interface  NCPNoiseRecorder()

@property (nonatomic) AVAudioRecorder *audioRecorder;

@property (nonatomic) NSTimer *timer;

@end

@implementation NCPNoiseRecorder

- (void) initAudiRecorder
{
    if (!self.audioRecorder)
    {
        NSError *error = nil ;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self filePath] settings:[self audioSettings] error:&error];
        self.audioRecorder.meteringEnabled = YES;
        if(error){
            NCPLogVerbose(@"Error when recorder inits,%@",error.localizedDescription);
        }
        if(![self.audioRecorder prepareToRecord]){
            NCPLogVerbose(@"Error when recorder prepare", nil);
        }
    }

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

- (void)startWithDuration:(NSTimeInterval)duration{
    [self.delegate willStartRecording];
    
    [self initAudiRecorder];
    
    if(self.audioRecorder.isRecording)
        return;
    [self.audioRecorder record];
    [self.audioRecorder updateMeters];
    
    [NSTimer scheduledTimerWithTimeInterval:duration
                                     target:self
                                   selector:@selector(timerAction:)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void)stop{
    [self.audioRecorder updateMeters];
    [self.delegate didUpdateAveragePower:100+[self.audioRecorder averagePowerForChannel:0]
                               PeakPower:100+[self.audioRecorder peakPowerForChannel:0]];
    [self.audioRecorder stop];
    self.audioRecorder = nil;
    
    [self.delegate didStopRecording];
}

- (void)timerAction:(NSTimer*) timer{
    [self stop];
}

@end
