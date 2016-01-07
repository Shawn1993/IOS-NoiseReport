//
//  NCPComplainFormManagedObject+CoreDataProperties.h
//  NoiseComplain
//
//  Created by mura on 1/5/16.
//  Copyright © 2016 sysu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCPComplainFormManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCPComplainFormManagedObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *altitude;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSNumber *intensity;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *noiseType;
@property (nullable, nonatomic, retain) NSString *sfaType;
@property (nullable, nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END
