//
//  NCPNoiseTypeViewController.m
//  NoiseComplain
//
//  Created by mura on 12/24/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPNoiseTypeViewController.h"
#import "NCPComplainFormTableViewCell.h"

NSString *kNCPNoiseTypePListFileName = @"NoiseType";

#pragma mark Private category

@interface NCPNoiseTypeViewController ()

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
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"NCPNoiseTypeViewController - cellForRowAtIndexPath");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNCPComplainFormTableCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"nil");
    }

    NSUInteger row = indexPath.row;
    cell.textLabel.text = self.pList[row][@"name"];
    
    return cell;
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

#pragma mark - Getter & Setter

- (NSArray *)pList {
    if (!_pList) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:kNCPNoiseTypePListFileName ofType:@"plist"];
        _pList = [[NSArray alloc] initWithContentsOfFile:plistPath];
        NSLog(@"%@", _pList);
    }
    NSLog(@"%@", _pList);
    return _pList;
}

@end
