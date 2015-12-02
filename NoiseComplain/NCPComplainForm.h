//
//  NCPComplainForm.h
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 mura. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 噪声类别枚举类型定义 */
typedef enum : NSUInteger {
    NCPNoiseTypeA,
    NCPNoiseTypeB,
    NCPNoiseTypeC
} NCPNoiseTypeEnum;

/** 声功能区枚举类型定义 */
typedef enum : NSUInteger {
    NCPSoundFunctionalAreaTypeA,
    NCPSoundFunctionalAreaTypeB,
    NCPSoundFunctionalAreaTypeC,
} NCPSoundFunctionalAreaTypeEnum;

/** 投诉表单类: 保存一次投诉的数据, 便于处理和归档 */
@interface NCPComplainForm : NSObject

/** 上次检测得到的一组有效的声强数据 */
@property (strong, nonatomic) NSArray *historyIntensity;
/** 检测周期内平均的声强数据 */
@property (assign, nonatomic) double averageIntensity;

/** 噪声源地理位置数据 */
// TODO: 根据实现添加此字段

/** 噪声类型 */
@property (assign, nonatomic) NCPNoiseTypeEnum noiseType;
/** 声功能区类型 */
@property (assign, nonatomic) NCPSoundFunctionalAreaTypeEnum soundFunctionalAreaType;

/** 附加文字信息 */
@property (copy, nonatomic) NSString *comment;
/** 附加图片信息 */
// TODO: 根据实现添加此字段

@end
