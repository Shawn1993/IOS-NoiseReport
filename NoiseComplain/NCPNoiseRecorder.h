//
//  NCPNoiseRecorder.h
//  NoiseComplain
//
//  Created by cheikh on 25/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NCPRecorderBlock)(float averagePower, float peakPower);

@interface NCPNoiseRecorder : NSObject

- (void)start;
- (void)finishUsingBlock:(NCPRecorderBlock)block;
- (void)finish;

@end
