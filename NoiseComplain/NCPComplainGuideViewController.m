//
//  NCPComplainGuideViewController.m
//  NoiseComplain
//
//  Created by mura on 12/1/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPComplainGuideViewController.h"
#import "NCPComplainForm.h"
#import "NCPSQLiteDAO.h"

#import "LGAlertView.h"

#pragma mark - 常量定义

// 历史投诉表格单元格标识符
static NSString *kNCPCellIdHistory = @"historyCell";
// 空历史投诉单元格标识符
static NSString *kNCPCellIdEmptyHistory = @"emptyHistoryCell";
// 投诉按钮单元格标识符
static NSString *kNCPCellIdComplain = @"complainCell";

// 提交投诉Segue标识符
static NSString *kNCPSegueIdToComplainForm = @"ComplainGuideToComplainForm";
// 投诉记录详情Segue标识符
static NSString *kNCPSegueIdToDetail = @"ComplainGuideToDetail";

@interface NCPComplainGuideViewController ()

#pragma mark - StoryBoard输出口

// 历史投诉TableView
@property(weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - 成员变量

// 历史投诉列表
@property(nonatomic) NSArray *historyArray;

// 选择的投诉记录索引
@property(nonatomic) int historyIndex;

@end

@implementation NCPComplainGuideViewController

#pragma mark - ViewController生命周期

// 视图载入
- (void)viewDidLoad {
    // 设置编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

// 视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    // 检查历史投诉
    [self reloadHistoryData];
    [self.tableView reloadData];
}

#pragma mark - 表格数据源

// 重新载入投诉记录数据
- (void)reloadHistoryData {
    self.historyArray = [NCPSQLiteDAO selectAllComplainForm];
    [self.tableView reloadData];
}

// 表格Section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 表格每Section行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            // 第一个Section只有一个投诉按钮
            return 1;
        case 1: {
            if (self.historyArray.count == 0) {
                // 如果没有投诉记录, 返回一个空行
                return 1;
            } else {
                // 有投诉记录, 每个记录返回一行
                return self.historyArray.count;
            }
        }
        default:
            return 0;
    }
}

// 表格每Section的标题
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

// 表格单元格数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            // 提交投诉按钮Section
            return [tableView dequeueReusableCellWithIdentifier:kNCPCellIdComplain];
        }
        case 1: {
            // 历史投诉Section
            if (self.historyArray.count == 0) {
                // 没有历史投诉
                return [tableView dequeueReusableCellWithIdentifier:kNCPCellIdEmptyHistory];
            } else {

                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNCPCellIdHistory];
                // 设置表格行显示内容
                NCPComplainForm *form = self.historyArray[(NSUInteger) indexPath.row];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy/MM/dd"];
                NSString *dateStr = [df stringFromDate:form.date];

                cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", dateStr, form.address];

                // 设置地址显示方式
                return cell;
            }
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - 表格点击事件与Segue跳转

// 表格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 点击了"点击开始投诉"单元格
        [self performSegueWithIdentifier:kNCPSegueIdToComplainForm sender:self];
    } else if (indexPath.section == 1) {
        if (self.historyArray.count == 0) {
            // 点击了"没有投诉记录"单元格
            LGAlertView *complainAlert = [LGAlertView alertViewWithTitle:@"没有投诉记录"
                                                                 message:@"还没有进行过投诉, 要提交噪声投诉吗?"
                                                                   style:LGAlertViewStyleAlert
                                                            buttonTitles:@[@"投诉"]
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                           actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                               [self performSegueWithIdentifier:kNCPSegueIdToComplainForm sender:self];
                                                           }
                                                           cancelHandler:nil
                                                      destructiveHandler:nil];
            [complainAlert showAnimated:YES completionHandler:nil];
        } else {
            // 点击了某个投诉记录
            self.historyIndex = (int) indexPath.row;
        }
    }
    // 取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Segue跳转前传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNCPSegueIdToDetail]) {
        // 如果是去向记录详情的Segue
        id dest = segue.destinationViewController;
        [dest setValue:self.historyArray[(NSUInteger) self.historyIndex] forKey:@"form"];
    }
    [super prepareForSegue:segue sender:sender];
}


#pragma mark - 表格编辑功能

// 开始编辑表格
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

// 返回单元格是否可以编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.historyArray.count > 0) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

// 表格被编辑事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NCPSQLiteDAO deleteComplainForm:self.historyArray[(NSUInteger) indexPath.row]];
        [self reloadHistoryData];
        [self.tableView reloadData];
    }
}

@end
