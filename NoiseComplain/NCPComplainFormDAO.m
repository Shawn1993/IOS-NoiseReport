//
//  NCPComplainFormDAO.m
//  NoiseComplain
//
//  Created by mura on 12/22/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainFormDAO.h"
#import "NCPComplainFormManagedObject+CoreDataProperties.h"

@implementation NCPComplainFormDAO

- (NSString *)entityName {
    return @"ComplainForm";
}

- (id)objectWithManagedObject:(NSManagedObject *)mo {
    NCPComplainFormManagedObject *tmo = (NCPComplainFormManagedObject *) mo;
    NCPComplainForm *tmodel = [[NCPComplainForm alloc] init];
    tmodel.formId = tmo.formId;
    tmodel.comment = tmo.comment;
    tmodel.date = tmo.date;
    tmodel.intensity = tmo.intensity;
    tmodel.latitude = tmo.latitude;
    tmodel.longitude = tmo.longitude;
    tmodel.sfaType = tmo.sfaType;
    tmodel.noiseType = tmo.noiseType;
    tmodel.address = tmo.address;
    return tmodel;
}

- (NSManagedObject *)assignWithObject:(id)model managedObject:(NSManagedObject *)mo {
    NCPComplainForm *tmodel = (NCPComplainForm *) model;
    NCPComplainFormManagedObject *tmo = (NCPComplainFormManagedObject *) mo;
    tmo.formId = tmodel.formId;
    tmo.comment = tmodel.comment;
    tmo.date = tmodel.date;
    tmo.intensity = tmodel.intensity;
    tmo.latitude = tmodel.latitude;
    tmo.longitude = tmodel.longitude;
    tmo.sfaType = tmodel.sfaType;
    tmo.noiseType = tmodel.noiseType;
    tmo.address = tmodel.address;
    return tmo;
}

- (NSString *)keyName {
    return @"formId";
}

- (NSString *)predicate {
    return @"formId = %@";
}

- (id)keyValue:(id)model {
    return ((NCPComplainForm *) model).formId;
}

@end
