//
//  EditViewController.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "EditViewController.h"
#import "NoteService.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;

@property (strong,nonatomic) NoteService *noteService;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.currentNote) {
        self.titleText.text = self.currentNote.title;
        self.bodyText.text = self.currentNote.body;
    }

    // fix the problem that textview doesn't start from the first line , it's caused by navigationBar since IOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (IBAction)saveNote:(UIBarButtonItem *)sender {
    _currentNote.title = self.titleText.text;
    _currentNote.body = self.bodyText.text;
    _currentNote.lastModifiedDate = [NSDate date];

    [self.noteService updateNote];

    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.titleText.text = self.currentNote.title;
    self.bodyText.text = self.currentNote.body;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NoteService *)noteService{
    if (!_noteService) {
        _noteService = [[NoteService alloc] init];
    }
    return _noteService;
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
