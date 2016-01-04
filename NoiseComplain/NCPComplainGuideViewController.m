//
//  NCPComplainGuideViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainGuideViewController.h"
#import "NCPComplainFormDAO.h"

@interface NCPComplainGuideViewController ()

@property (strong, nonatomic) NSArray *historyArray;

@end

@implementation NCPComplainGuideViewController

- (void)viewDidLoad {
    
    // 检查历史投诉
    NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
    self.historyArray = [dao findAll];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}


@end
