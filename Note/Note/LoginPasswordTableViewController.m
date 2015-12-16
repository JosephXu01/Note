//
//  PasswordTableViewController.m
//  Note
//
//  Created by Shallong on 15/12/15.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "LoginPasswordTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "UserService.h"
#import "NoteUtil.h"
#import "NSUserDefaultsHelper.h"
#import "User.h"

@interface LoginPasswordTableViewController ()
@property (strong,nonatomic) UIButton *saveButton;

@property (strong,nonatomic) UserService *userService;

@end

@implementation LoginPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UITableView *groupedTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];

    self.tableView = groupedTableView;

    self.tableView.allowsSelection = NO;

    self.tableView.tableFooterView = self.saveButton;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;

        default:
            return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldTableViewCell *textCell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if (indexPath.section == 0) {
        textCell.textField.placeholder = @"Original password";
    }else {
        textCell.textField.placeholder = @"New password";
    }

    return textCell;
}

-(void)savePassword:(UIButton *)sender{
    NSString *originalPassword = [self getPasswordWithSection:0 andRow:0];
    NSString *newPassword = [self getPasswordWithSection:1 andRow:0];
    NSString *secondNewPassword = [self getPasswordWithSection:1 andRow:1];

    NSString *warningMessage = [self.userService passwordCheckWithOriginalPass:originalPassword andFirstNewPass:newPassword andSecondNewPass:secondNewPassword];

    if (warningMessage) {
        //alert
        UIAlertController *alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:warningMessage];

        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        //save
        User *user = [self.userService getUser];

        user.loginPassword = newPassword;

        [NSUserDefaultsHelper setLoginPassword:newPassword];

        [self.userService updateUser];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString *)getPasswordWithSection:(NSInteger)section andRow:(NSInteger)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row  inSection:section];
    TextFieldTableViewCell *cell1 = (TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *password = cell1.textField.text;

    return password;
}

-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];

        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _saveButton.frame = CGRectMake(0, 0, screenWidth, 30);

        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setBackgroundColor:[UIColor purpleColor]];
        [_saveButton addTarget:self action:@selector(savePassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}


-(UserService *)userService{
    if (!_userService) {
        _userService = [[UserService alloc] init];
    }
    return _userService;
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
