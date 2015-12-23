//
//  NCPComplainForm.h
//  NoiseComplain
//
//  Created by mura on 11/28/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  投诉表单类: 保存一次投诉表单的内容
 */
@interface NCPComplainForm : NSObject

@property (nullable, nonatomic, retain) NSString *comment;
@property (nonnull, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *intensity;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *altitude;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *sfaType;
@property (nullable, nonatomic, retain) NSString *noiseType;

@end
