//
//  NCPSFATypeViewController.m
//  NoiseComplain
//
//  Created by mura on 12/24/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPSFATypeViewController.h"
#import "NCPComplainForm.h"

/*!声功能区类型plist文件名*/
NSString *kNCPSFATypePListFileName = @"SFAType";
/*!表格文字内容键名(String)*/
NSString *kNCPSFATypePListTextKey = @"name";
/*!表格图标名键名(String, 对应Assets.xcassets)*/
NSString *kNCPSFATypePListImageKey = @"image";
/*!当表格图标不存在时的默认图标名*/
NSString *kNCPSFATypeDefaultImage = @"";

/*!可重用单元格标识符*/
static NSString *kNCPSFATypeCellIdentifier = @"sfaTypeTableCell";

#pragma mark Private category

@interface NCPSFATypeViewController ()

/*!plist文件对应Array*/
@property (strong, nonatomic) NSArray *pList;

@end

#pragma mark - Implementation

@implementation NCPSFATypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 读取plist文件内容
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kNCPSFATypePListFileName ofType:@"plist"];
    _pList = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Datasource: 为表格提供单元格
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNCPSFATypeCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        NSUInteger row = indexPath.row;
        
        // 文字
        cell.textLabel.text = self.pList[row][kNCPSFATypePListTextKey];
        
        // 图标
        cell.imageView.image = [UIImage imageNamed:self.pList[row][kNCPSFATypePListImageKey]];
        if (!cell.imageView.image) {
            if (kNCPSFATypeDefaultImage) {
                cell.imageView.image = [UIImage imageNamed:kNCPSFATypeDefaultImage];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 表格被点击事件
    NSUInteger row = indexPath.row;
    NCPComplainForm *form = [NCPComplainForm current];
    
    // 为当前表单的声功能区类型赋值
    form.sfaType = self.pList[row][kNCPSFATypePListTextKey];
    
    // 返回上一页面
    [self.navigationController popViewControllerAnimated:YES];
}

@end
