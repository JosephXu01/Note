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
@property (weak, nonatomic) IBOutlet UILabel *successLable1;
@property (weak, nonatomic) IBOutlet UILabel *successLable2;

@property (strong,nonatomic) UserService *userService;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.nickNameText.delegate = self;
    self.accountText.delegate = self;
    self.passwordText.delegate = self;

    [self.successLable1 setHidden:YES];
    [self.successLable2 setHidden:YES];

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
    [self.view endEditing:YES];

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

        //show success info
        [self.successLable1 setHidden:NO];
        [self.successLable2 setHidden:NO];

        NSTimer *delayTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(  redirectToLogInPage) userInfo:nil repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:delayTimer forMode:NSDefaultRunLoopMode];
        }
}

-(void)redirectToLogInPage{
    //return to login page
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)returnToLogInPage:(UIButton *)sender {
    [self redirectToLogInPage];
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

@end
