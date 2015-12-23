//
//  NCPComplainFormDAO.m
//  NoiseComplain
//
//  Created by mura on 12/22/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainFormDAO.h"
#import "NCPComplainFormManagedObject+CoreDataProperties.h"
#import "NCPComplainForm.h"

@implementation NCPComplainFormDAO

- (NSString *)entityName {
    return @"ComplainForm";
}

- (id)objectWithManagedObject:(NSManagedObject *)mo {
    NCPComplainFormManagedObject *tmo = (NCPComplainFormManagedObject *)mo;
    NCPComplainForm *model = [[NCPComplainForm alloc] init];
    model.comment = tmo.comment;
    model.date = tmo.date;
    model.intensity = tmo.intensity;
    model.latitude = tmo.latitude;
    model.longitude = tmo.longitude;
    model.altitude = tmo.altitude;
    model.image = tmo.image;
    model.sfaType = tmo.sfaType;
    model.noiseType = tmo.noiseType;
    return model;
}

- (NSManagedObject *)assignWithObject:(id)model managedObject:(NSManagedObject *)mo {
    NCPComplainForm *tmodel = (NCPComplainForm *)model;
    NCPComplainFormManagedObject *tmo = (NCPComplainFormManagedObject *)mo;
    tmo.comment = tmodel.comment;
    tmo.date = tmodel.date;
    tmo.intensity = tmodel.intensity;
    tmo.latitude = tmodel.latitude;
    tmo.longitude = tmodel.longitude;
    tmo.altitude = tmodel.altitude;
    tmo.image = tmodel.image;
    tmo.sfaType = tmodel.sfaType;
    tmo.noiseType = tmodel.noiseType;
    return tmo;
}

- (NSString *)keyName {
    return @"date";
}

- (id)keyValueWithObject:(id)model {
    return ((NCPComplainForm *)model).date;
}

@end
