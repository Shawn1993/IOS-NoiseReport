//
//  NCPComplainFormDAO.m
//  NoiseComplain
//
//  Created by mura on 12/20/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainFormDAO.h"

@implementation NCPComplainFormDAO

- (NSMutableArray *)findAll {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ComplainForm" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchRequest
                                               error:&error];
    NSMutableArray *resListData = [NSMutableArray array];
    
    // TODO: 向数组中添加内容
    
    return resListData;
}

- (BOOL)create:(NCPComplainForm *)form {
    return YES;
}

- (BOOL)remove:(NCPComplainForm *)form {
    return YES;
}

@end
