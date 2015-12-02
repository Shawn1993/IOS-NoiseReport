//
//  NCPNoiseMeter.h
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 mura. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 噪声仪类: 实现噪声强度的检测和记录等功能 */
@interface NCPNoiseMeter : NSObject

/** 获取NCPNoiseMeter的单例实例 */
+ (NCPNoiseMeter *)getInstance;

/** 开始检测并记录数据: 计时器每跳的回调Block(刷新UI等) */
- (void)startWithCallback:(void(^)(void))callback;
/** 暂停噪声检测 */
- (void)pause;
/** 继续噪声检测 */
- (void)resume;
/** 停止记录数据 */
- (void)stop;

/** 最后一次平均值 */
@property (readonly, assign, nonatomic) double lastAvg;
/** 最后一次峰值 */
@property (readonly, assign, nonatomic) double lastPeak;

@end
