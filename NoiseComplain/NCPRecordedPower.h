//
//  NCPRecordedPower.h
//  NoiseComplain
//
//  Created by cheikh on 26/12/2015.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCPRecordedPower : NSObject

@property (nonatomic,strong) NSNumber *averagePower;
@property (nonatomic,strong) NSNumber *peakPower;
@property (nonatomic,strong) NSData *recordedData;

@end
