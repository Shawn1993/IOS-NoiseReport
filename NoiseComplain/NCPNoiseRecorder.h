//
//  NCPNoiseRecorder.h
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float NCPPower;

typedef void (^NCPRecorderBlock)(NCPPower averagePower, NCPPower peakPower);


@protocol NCPNoiseRecorderDelegate;

@interface NCPNoiseRecorder : NSObject

- (void)startWithDuration:(NSTimeInterval)duration;

- (void)start;

- (void)stop;

@property(nonatomic) id <NCPNoiseRecorderDelegate> delegate;

@end


@protocol NCPNoiseRecorderDelegate <NSObject>

@optional

- (void)willStartRecording;

- (void)didStopRecording;

- (void)didUpdateAveragePower:(NCPPower)averagePoer PeakPower:(NCPPower)peakPower;

@end