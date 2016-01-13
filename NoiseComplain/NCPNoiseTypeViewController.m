//
//  NCPNoiseTypeViewController.m
//  NoiseComplain
//
//  Created by mura on 12/24/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseTypeViewController.h"
#import "NCPComplainFormTableViewCell.h"
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

#pragma mark Private category

@interface NCPNoiseTypeViewController ()

/*!plist文件对应Array*/
@property (strong, nonatomic) NSArray *pList;

@end

#pragma mark - Implementation

@implementation NCPNoiseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNCPComplainFormTableCellIdentifier forIndexPath:indexPath];
    
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
