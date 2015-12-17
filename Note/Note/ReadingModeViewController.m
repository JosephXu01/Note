//
//  ReadingModeViewController.m
//  Note
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "ReadingModeViewController.h"
#import "Note.h"

#define STATUS_BAR_HEIGHT 30
#define TOOLBAR_HEIGHT 44

@interface ReadingModeViewController ()
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UIToolbar *toolbar;

@end

@implementation ReadingModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];

    self.view.backgroundColor = [UIColor greenColor];

    if (_currentNode) {
        self.textView.text = _currentNode.body;
    }

    [self.view addSubview:self.textView];
}

//TODO:auto layout
-(void)initView{
    _textView = [[UITextView alloc] init];
    _toolbar = [[UIToolbar alloc] init];

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    _textView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, screenWidth, screenHeight - STATUS_BAR_HEIGHT - TOOLBAR_HEIGHT);

    _toolbar.frame = CGRectMake(0, screenHeight - TOOLBAR_HEIGHT , screenWidth,TOOLBAR_HEIGHT);

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];

    [_toolbar setItems:@[backBarButtonItem]];

    [self.view addSubview:_textView];
    [self.view addSubview:_toolbar];


}

-(void)back:(UIBarButtonItem *)backBarButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
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
