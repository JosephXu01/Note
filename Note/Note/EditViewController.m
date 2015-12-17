//
//  EditViewController.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "EditViewController.h"
#import "NoteService.h"
#import "MoreActionTableViewController.h"
#import "ReadingModeViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;

@property (strong,nonatomic) NoteService *noteService;

@end

@implementation EditViewController
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.currentNote) {
        self.titleText.text = self.currentNote.title;
        self.bodyText.text = self.currentNote.body;
    }


//      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToNoteList:)];

    // fix the problem that textview doesn't start from the first line , it's caused by navigationBar since IOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (IBAction)saveNote:(UIBarButtonItem *)sender {
    [self.bodyText.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, self.bodyText.text.length)];

    _currentNote.title = self.titleText.text;
    _currentNote.body = self.bodyText.attributedText.string;
    _currentNote.lastModifiedDate = [NSDate date];

    [self.noteService updateNote];

    [self.view endEditing:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTEUPDATEDNOTIFICATION object:self userInfo:@{UPDATEDNOTE : _currentNote}];
}

//-(void)backToNoteList:(UIBarButtonItem *)sender {
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)viewWillAppear:(BOOL)animated{
    self.titleText.text = self.currentNote.title;
    self.bodyText.text = self.currentNote.body;
}
- (IBAction)readingModeClicked:(UIBarButtonItem *)sender {
    ReadingModeViewController *readingModeViewController = [[ReadingModeViewController alloc] init];

    readingModeViewController.currentNode = self.currentNote;

    [self presentViewController:readingModeViewController animated:YES completion:nil];
    
}

- (IBAction)moreButtonClicked:(UIBarButtonItem *)sender {
    MoreActionTableViewController *moreActionViewController = [[MoreActionTableViewController alloc] init];

    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:moreActionViewController];

    self.popoverController.delegate = self;
    self.popoverController.popoverContentSize = moreActionViewController.preferredContentSize;

    [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
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
