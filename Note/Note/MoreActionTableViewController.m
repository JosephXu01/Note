//
//  MoreActionTableViewController.m
//  Note
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "MoreActionTableViewController.h"
#define DELETE @"Delete"
@interface MoreActionTableViewController ()

@property (strong,nonatomic) NSArray *actionsArray;

@end

@implementation MoreActionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.actionsArray = @[DELETE];

    self.preferredContentSize = CGSizeMake(100, 44 * self.actionsArray.count - 1);

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
    return self.actionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    cell.textLabel.text = self.actionsArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *label = selectedCell.textLabel.text;

    if([label isEqualToString:DELETE]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_DELETED_FROM_EDIT_PAGE object:self userInfo:@{NOTE_TO_DELETE : self.currentNote}];
        
        [self.editViewController.popoverController dismissPopoverAnimated:YES];

#warning //TODO: below code is not working in splitView on iphone ,
        //[[self.editViewController.navigationController popViewControllerAnimated:YES];

        NSLog(@"......%@",self.editViewController.navigationController);

        UINavigationController *navi = (UINavigationController *)self.editViewController.parentViewController;

        [navi popViewControllerAnimated:YES];
    }
}

@end
