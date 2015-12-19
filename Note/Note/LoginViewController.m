//
//  LoginViewController.m
//  Note
//
//  Created by Shallong on 15/12/13.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "LoginViewController.h"
#import "UserService.h"
#import "MainViewController.h"
#import "User.h"
#import "NoteUtil.h"
#import "NSUserDefaultsHelper.h"
#import "RegisterViewController.h"
#import "EditViewController.h"

@interface LoginViewController () <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (strong,nonatomic) UserService *userService;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.accountText.delegate = self;
    self.passwordText.delegate = self;

}
- (IBAction)login:(UIButton *)sender {

    NSString *account = self.accountText.text;
    NSString *password = self.passwordText.text;

    NSString *warningMessage = [self.userService loginInfoCheck:account andPassword:password];
    if (warningMessage) {
            //show alert
        UIAlertController *alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:warningMessage];
        [self presentViewController:alertController animated:YES completion:nil];

    }else{
        User *user = [self.userService getUserByAccount:self.accountText.text andPassword:self.passwordText.text];

        [NSUserDefaultsHelper setAccount:user.loginAccount andPassword:user.loginPassword andName:user.nickName andFaceImage:user.faceImage];

        [self presentViewController:[NoteUtil jumpToView:MAIN] animated:YES completion:nil];

        UISplitViewController *splitViewController = (UISplitViewController *)self.presentedViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        splitViewController.delegate = self;
    }
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[EditViewController class]] && ([(EditViewController *)[(UINavigationController *)secondaryViewController topViewController] currentNote] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)createNewAccount:(UIButton *)sender {
    //init from storyboard
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
    [self presentViewController:registerViewController animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.passwordText becomeFirstResponder];
    }

    return YES;
}

-(UserService *)userService{
    if (!_userService) {
        _userService = [[UserService alloc] init];
    }
    return _userService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
