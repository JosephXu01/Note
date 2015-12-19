//
//  ViewController.m
//  UICollectionViewTest
//
//  Created by Shallong on 15/12/19.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "ReadingPasswordInputViewController.h"
#import "NSUserDefaultsHelper.h"
#import "NoteUtil.h"
#import "EditViewController.h"

#define STAR @"✶"

@interface ReadingPasswordInputViewController () <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UITextField *password3;
@property (weak, nonatomic) IBOutlet UITextField *password4;
@property (weak, nonatomic) IBOutlet UITextField *hiddenTextField;
@property (weak, nonatomic) IBOutlet UILabel *wrongPasswordLabel;

@end

@implementation ReadingPasswordInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //hide mouse
    self.password1.tintColor = [UIColor clearColor];
    self.password2.tintColor = [UIColor clearColor];
    self.password3.tintColor = [UIColor clearColor];
    self.password4.tintColor = [UIColor clearColor];

    self.password1.textAlignment = NSTextAlignmentCenter;
    self.password2.textAlignment = NSTextAlignmentCenter;
    self.password3.textAlignment = NSTextAlignmentCenter;
    self.password4.textAlignment = NSTextAlignmentCenter;

    [self.hiddenTextField setHidden:YES];
    [self.hiddenTextField becomeFirstResponder];

    [self.wrongPasswordLabel setHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];

}

-(void)textChanged{
    NSString *password = self.hiddenTextField.text;

    [self setStar:password.length];

    if (password.length == 4) {
        if (self.setPassword) {
            [self setReadingPassword:password];
        }else{
            [self unLock:password];
        }
    }
}

-(void)setReadingPassword:(NSString *)password{
    [NSUserDefaultsHelper setReadingPassword:password];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)unLock:(NSString *)password{
    NSString *readingPassword = [NSUserDefaultsHelper getReadingPassword];

    if ([password isEqualToString:readingPassword]) {
        [self presentViewController:[NoteUtil jumpToView:MAIN] animated:YES completion:nil];

        UISplitViewController *splitViewController = (UISplitViewController *)self.presentedViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        splitViewController.delegate = self;
    }else{
        self.hiddenTextField.text = @"";
        [self.wrongPasswordLabel setHidden:NO];
        //[self setStar:0];
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

-(void)setStar:(NSInteger)count{
    for (int i = 1; i <= 4; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];

        if (i <= count) {
            textField.text = STAR;
        }else{
            textField.text = @"";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
