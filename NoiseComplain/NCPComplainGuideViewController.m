//
//  NCPComplainGuideViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainGuideViewController.h"
#import "NCPComplainFormDAO.h"
#import "NCPMapAlertViewController.h"

#pragma mark - 常量定义

// 代表空的提示字符串
static NSString *kNilStr = @"null";

// 日期格式字符串
static NSString *kDateFmtStr = @"yyyy/MM/dd";

// 历史投诉表格单元格标识符
static NSString *kCellIdHistory = @"historyCell";
// 空历史投诉单元格标识符
static NSString *kCellIdEmptyHistory = @"emptyHistoryCell";
// 投诉按钮单元格标识符
static NSString *kCellIdComplain = @"complainCell";

@interface NCPComplainGuideViewController ()

#pragma mark - 成员变量

// 历史投诉列表
@property(strong, nonatomic) NSArray *historyArray;

// 历史投诉TableView
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NCPComplainGuideViewController

#pragma mark - ViewController生命周期

- (void)viewDidLoad {
    // 设置编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    // 检查历史投诉
    [self reloadDataFromCoreData];
    [self.tableView reloadData];
}

#pragma mark - 表格代理与数据源

- (void)reloadDataFromCoreData {
    NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
    self.historyArray = [dao findAll];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 设置表格
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1: {
            if (self.historyArray.count == 0) {
                // 如果没有历史投诉, 返回一个空行
                return 1;
            } else {
                return self.historyArray.count;
            }
        }
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
            return @"投诉记录列表";
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            // 提交投诉按钮Section
            return [tableView dequeueReusableCellWithIdentifier:kCellIdComplain];
        }
        case 1: {
            // 历史投诉Section
            if (self.historyArray.count == 0) {
                // 没有历史投诉
                return [tableView dequeueReusableCellWithIdentifier:kCellIdEmptyHistory];
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdHistory];
                // 设置表格行显示内容
                NCPComplainForm *form = self.historyArray[(NSUInteger) indexPath.row];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:kDateFmtStr];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                                                 form.date ? [df stringFromDate:form.date] : kNilStr, form.address ? form.address : kNilStr];
                return cell;
            }
        }
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        if (self.historyArray.count > 0) {
            // 历史投诉Section

            // 组织提示框内容
            NCPComplainForm *form = self.historyArray[(NSUInteger) indexPath.row];
            NSString *title = form.address ? [NSString stringWithFormat:@"%@", form.address] : @"投诉详情";
            NSMutableString *msg = [NSMutableString string];
            [msg appendFormat:@"投诉单号: %@\n", form.formId];
            [msg appendString:@"投诉日期: "];
            if (form.date) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:kDateFmtStr];
                [msg appendFormat:@"%@\n", [df stringFromDate:form.date]];
            } else {
                [msg appendFormat:@"%@\n", kNilStr];
            }
            [msg appendFormat:@"投诉地点: %@\n", form.address ? form.address : kNilStr];
            [msg appendFormat:@"噪声强度: %.1f dB", form.intensity ? form.intensity.floatValue : 0.0f];
            if (form.comment && form.comment.length > 0) {
                [msg appendFormat:@"\n\n%@", form.comment];
            }

            // 显示提示框
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

            [ac addAction:cancel];
            UIAlertAction *map = [UIAlertAction actionWithTitle:@"查看地图"
                                                          style:UIAlertActionStyleDefault
                                                        handler:(void (^)(UIAlertAction *)) ^{
                                                            NCPMapAlertViewController *mapController = [NCPMapAlertViewController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                                                                                                   message:nil
                                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction *ma = [UIAlertAction actionWithTitle:@"关闭地图"
                                                                                                          style:UIAlertActionStyleDefault
                                                                                                        handler:nil];
                                                            [mapController addAction:ma];
                                                            [mapController addAction:cancel];
                                                            [self presentViewController:mapController animated:NO completion:nil];
                                                        }];
            [ac addAction:map];
            [self presentViewController:ac animated:YES completion:nil];

        } else {
            // "没有历史投诉"
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"还没有投诉记录"
                                                                        message:@"要开始噪声投诉吗?"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *complain = [UIAlertAction actionWithTitle:@"投诉"
                                                               style:UIAlertActionStyleDefault
                                                             handler:(void (^)(UIAlertAction *)) ^{
                                                                 [self performSegueWithIdentifier:@"complainSegue" sender:self];
                                                             }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:complain];
            [ac addAction:cancel];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
    // 取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 返回是否可以编辑
    if (indexPath.section == 1) {
        if (self.historyArray.count > 0) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
        [dao remove:self.historyArray[(NSUInteger) indexPath.row]];
        [self reloadDataFromCoreData];
        [self.tableView reloadData];
    }
}

@end
