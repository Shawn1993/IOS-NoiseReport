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
    
    // 添加一个测试表单
    NCPComplainForm *form = [[NCPComplainForm alloc] init];
    form.comment = @"测试用表单记录1";
    form.sfaType = @"学校";
    form.noiseType = @"舍友";
    form.latitude = @10.24;
    form.longitude = @100;
    form.altitude = @9999;
    form.intensity = @999999;
    [dao create:form];
    
        self.historyArray = [dao findAll];
    NSLog(@"%@", self.historyArray);
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
