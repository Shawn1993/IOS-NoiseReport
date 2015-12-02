//
//  NCPComplainFormViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 mura. All rights reserved.
//

#import "NCPComplainFormViewController.h"

@interface NCPComplainFormViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender;
/** 导航栏按钮Clear点击事件 */
- (IBAction)barButtonClearClick:(id)sender;

@end

@implementation NCPComplainFormViewController

#pragma mark - UIPickerView数据源协议

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

#pragma mark - UITableView数据源协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - 控件事件

/** 导航栏按钮Cancel点击事件 */
- (IBAction)barButtonCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 导航栏按钮Clear点击事件 */
- (IBAction)barButtonClearClick:(id)sender {
    
}

@end
