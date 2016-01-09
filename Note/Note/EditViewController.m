//
//  EditViewController.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "EditViewController.h"
#import "NoteService.h"
#import "MoreActionTableViewController.h"
#import "ReadingModeViewController.h"
#import "AttributedBody.h"
#import "NoteUtil.h"

@interface EditViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;

@property (strong,nonatomic) NoteService *noteService;
@property (strong,nonatomic) AttributedBody *attributedBody;

@end

@implementation EditViewController
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureView];

    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];

    // fix the problem that textview doesn't start from the first line , it's caused by navigationBar since IOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)configureView{
    if (self.currentNote) {
        self.titleText.text = self.currentNote.title;

        //unarchive
        if (_currentNote.body) {
            self.attributedBody = [NSKeyedUnarchiver unarchiveObjectWithData:_currentNote.body];
        }

        self.bodyText.attributedText = _attributedBody.body;
    }
}

- (IBAction)saveNote:(UIBarButtonItem *)sender {
    if (_currentNote) {
        AttributedBody *attributedBody = [[AttributedBody alloc] init];
        attributedBody.body =  self.bodyText.attributedText;

        //archive
        NSData *bodyData = [NSKeyedArchiver archivedDataWithRootObject:attributedBody];

        _currentNote.title = self.titleText.text;
        _currentNote.body = bodyData;
        _currentNote.lastModifiedDate = [NSDate date];

        [self.noteService updateNote];

        [self.view endEditing:YES];

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_UPDATED_NOTIFICATION object:self];
    }
}

#pragma mark - mail
- (IBAction)sendEmail:(UIBarButtonItem *)sender {

    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertController *alertController =  [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:@"Mail account wasn't set!"];

        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        mailPicker.mailComposeDelegate = self;
        [mailPicker setSubject:self.currentNote.title];
        [mailPicker setMessageBody:[self.attributedBody.body string] isHTML:YES];

        [self presentViewController:mailPicker animated:YES completion:nil];
    }
}

#pragma mark - reading mode
- (IBAction)readingModeClicked:(UIBarButtonItem *)sender {
    ReadingModeViewController *readingModeViewController = [[ReadingModeViewController alloc] init];

    readingModeViewController.attributedString = [self.attributedBody.body mutableCopy];

    [self presentViewController:readingModeViewController animated:YES completion:nil];
    
}

#pragma mark - more
- (IBAction)moreButtonClicked:(UIBarButtonItem *)sender {
    MoreActionTableViewController *moreActionViewController = [[MoreActionTableViewController alloc] init];
    moreActionViewController.editViewController = self;
    moreActionViewController.currentNote = self.currentNote;

    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:moreActionViewController];

    self.popoverController.delegate = self;
    self.popoverController.popoverContentSize = moreActionViewController.preferredContentSize;

    [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

#pragma mark - mfmail delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];

    switch (result) {
        case MFMailComposeResultCancelled:

            break;
        case MFMailComposeResultSaved:

            break;
        case MFMailComposeResultFailed:

            break;
        case MFMailComposeResultSent:

            break;

        default:
            break;
    }

}

-(void)orientationDidChange{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        if (self.popoverController) {
            [self.popoverController dismissPopoverAnimated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get set
-(void)setCurrentNote:(Note *)currentNote{
    if (_currentNote != currentNote) {
        _currentNote = currentNote;

        [self configureView];
    }
}

-(NoteService *)noteService{
    if (!_noteService) {
        _noteService = [[NoteService alloc] init];
    }
    return _noteService;
}

-(AttributedBody *)attributedBody{
    if (!_attributedBody) {
        _attributedBody = [[AttributedBody alloc] init];
    }
    return _attributedBody;
}

@end
