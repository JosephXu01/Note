//
//  RegisterViewController.m
//  Note
//
//  Created by Shallong on 15/12/14.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterInfo.h"
#import "UserService.h"
#import "NoteUtil.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (strong,nonatomic) UserService *userService;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.nickNameText.delegate = self;
    self.accountText.delegate = self;
    self.passwordText.delegate = self;

    [self initPasswordSwitch];
}

-(void)initPasswordSwitch{
    UISwitch *passwordSwitch = [[UISwitch alloc] init];
    self.passwordText.rightView = passwordSwitch;
    self.passwordText.rightViewMode = UITextFieldViewModeAlways;
    self.passwordText.secureTextEntry = YES;
    [passwordSwitch setOn:YES];
    [passwordSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(UISwitch *)sender{
    if (sender.isOn) {
        [self.passwordText setSecureTextEntry:YES];
    }else{
        [self.passwordText setSecureTextEntry:NO];
    }
}

- (IBAction)userRegister:(UIButton *)sender {
    RegisterInfo *registerInfo = [[RegisterInfo alloc] init];
    registerInfo.nickName = self.nickNameText.text;
    registerInfo.account = self.accountText.text;
    registerInfo.password = self.passwordText.text;

    NSString *warningInfo = [self.userService registerInfoCheck:registerInfo];

    if (warningInfo) {
        //show alert
        UIAlertController *alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:warningInfo];

        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        //add user
        [self.userService newUserWithRegisterInfo:registerInfo];

        //return to login page
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
- (IBAction)returnToLogInPage:(UIButton *)sender {
    //return to login page
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];

    if (textField.returnKeyType == UIReturnKeyNext) {

        UITextField *nextTextFiled = (UITextField *)[self.view viewWithTag:(textField.tag+1)];
        [nextTextFiled becomeFirstResponder];
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
