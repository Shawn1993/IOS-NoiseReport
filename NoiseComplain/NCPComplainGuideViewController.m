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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NCPComplainGuideViewController

- (void)viewDidLoad {
    
    // 检查历史投诉
    NCPComplainFormDAO *dao = [NCPComplainFormDAO dao];
    self.historyArray = [dao findAll];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: cellIdentifier];
    }
    cell.textLabel.text= @"第一条投诉记录";

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.tableView.hidden = NO;
}

@end
