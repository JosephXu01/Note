//
//  ReadingPasswordViewController.m
//  Note
//
//  Created by Shallong on 15/12/15.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "ReadingPasswordViewController.h"
#import "NSUserDefaultsHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "NoteUtil.h"
#import "ReadingPasswordInputViewController.h"
@interface ReadingPasswordViewController ()

@property (strong,nonatomic) UISwitch *touchIDSwitch;
@property (strong,nonatomic) UISwitch *passwordSwitch;


@end

@implementation ReadingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *groupedTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];

    self.tableView = groupedTableView;
    
    [self initSwitchStatus];
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
            return 2;

        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"TouchID";
            cell.accessoryView = self.touchIDSwitch;
        }else{
            cell.textLabel.text = @"Reading Password";
            cell.accessoryView = self.passwordSwitch;
        }
    }else{
        cell.textLabel.text = @"Change Password";
        if (self.passwordSwitch.isOn) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && self.passwordSwitch.isOn) {
        ReadingPasswordInputViewController *passwordInputViewController = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:READING_PASSWORD_INPUT_VIEW_CONTROLLER];
        passwordInputViewController.setPassword = YES;

        [self.navigationController pushViewController:passwordInputViewController animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Open TouchID or Reading password";
    }
    return nil;
}

-(void)touchIDSwitchAction:(UISwitch *)sender{
    if (sender.isOn) {
        [NSUserDefaultsHelper setIsTouchIDUsed:YES];

        LAContext *context = [[LAContext alloc] init];

        NSError *error;

        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {

            [NSUserDefaultsHelper setIsTouchIDUsed:YES];
        }else{
            UIAlertController *alertController = nil;
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled:
                    alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:@"Touch ID has no enrolled fingers."];
                    break;

                case LAErrorPasscodeNotSet:
                    alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:@"Passcode is not set on the device."];
                    break;

                default:
                    alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:@"Touch ID is not available on the device."];
                    break;
            }

            [self.touchIDSwitch setOn:NO];
            [self presentViewController:alertController animated:YES completion:nil];

        }

    }else{
        [NSUserDefaultsHelper removeIsTouchIDUsed];

    }
}

-(void)passwordSwitchAction:(UISwitch *)sender{
    if (sender.isOn) {
        [self changePasswordCell].accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        //self.parentViewController is a navigationController,
        //self.storyboard is null, cause it's not from storyboard
        //self.presentingViewController is null
        ReadingPasswordInputViewController *passwordInputViewController = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:READING_PASSWORD_INPUT_VIEW_CONTROLLER];
        passwordInputViewController.setPassword = YES;

        [self.navigationController pushViewController:passwordInputViewController animated:YES];

    }else{
        [NSUserDefaultsHelper removeReadingPassword];

        [self changePasswordCell].accessoryType = UITableViewCellAccessoryNone;
    }
}

-(UITableViewCell *)changePasswordCell{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0  inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

-(void)initSwitchStatus{
    if ([NSUserDefaultsHelper isTouchIDUsed]) {
        [self.touchIDSwitch setOn:YES];
    }else{
        [self.touchIDSwitch setOn:NO];
    }

    if ([NSUserDefaultsHelper getReadingPassword]) {
        [self.passwordSwitch setOn:YES];
    }else{
        [self.passwordSwitch setOn:NO];
    }
}

-(UISwitch *)touchIDSwitch{
    if (!_touchIDSwitch) {
        _touchIDSwitch = [[UISwitch alloc] init];

        [_touchIDSwitch addTarget:self action:@selector(touchIDSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _touchIDSwitch;
}

-(UISwitch *)passwordSwitch{
    if (!_passwordSwitch) {
        _passwordSwitch = [[UISwitch alloc] init];

        [_passwordSwitch addTarget:self action:@selector(passwordSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _passwordSwitch;
}

@end
