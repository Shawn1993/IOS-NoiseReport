//
//  NCPNoiseTypeViewController.m
//  NoiseComplain
//
//  Created by mura on 12/24/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseTypeViewController.h"
#import "NCPLog.h"
#import "NCPComplainForm.h"

/*!噪声类型plist文件名*/
NSString *kNCPNoiseTypePListFileName = @"NoiseType";
/*!表格文字内容键名(String)*/
NSString *kNCPNoiseTypePListTextKey = @"name";
/*!表格图标名键名(String, 对应Assets.xcassets)*/
NSString *kNCPNoiseTypePListImageKey = @"image";
/*!当表格图标不存在时的默认图标名*/
NSString *kNCPNoiseTypeDefaultImage = nil;

/*!可充用单元格标识符*/
static NSString *kNCPNoiseTypeTableCellIdentifier = @"noiseTypeTableCell";

#pragma mark Private category

@interface NCPNoiseTypeViewController ()

/*!plist文件对应Array*/
@property (strong, nonatomic) NSArray *pList;

@end

#pragma mark - Implementation

@implementation NCPNoiseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 读取plist文件内容
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kNCPNoiseTypePListFileName ofType:@"plist"];
    _pList = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Datasource: 为表格提供单元格
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNCPNoiseTypeTableCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        NSUInteger row = indexPath.row;
        
        // 文字
        cell.textLabel.text = self.pList[row][kNCPNoiseTypePListTextKey];
        
//        // 图标
//        cell.imageView.image = [UIImage imageNamed:self.pList[row][kNCPNoiseTypePListImageKey]];
//        if (!cell.imageView.image) {
//            cell.imageView.image = [UIImage imageNamed:kNCPNoiseTypeDefaultImage];
//        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 表格行被点击事件
    NSUInteger row = indexPath.row;
    NCPComplainForm *form = [NCPComplainForm current];
    
    // 为当前表单的噪声类型赋值
    form.noiseType = self.pList[row][kNCPNoiseTypePListTextKey];
    
    // 返回上一页面
    [self.navigationController popViewControllerAnimated:YES];
}

@end
