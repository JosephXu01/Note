//
//  ReadingModeViewController.m
//  Note
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "ReadingModeViewController.h"
#import "Note.h"
#import "BackoundColorTableViewController.h"

#define STATUS_BAR_HEIGHT 20
#define TOOLBAR_HEIGHT 44

@interface ReadingModeViewController ()
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UIToolbar *toolbar;
@property (nonatomic, assign) CGFloat textSize;

@end

@implementation ReadingModeViewController

@synthesize popoverController;
@synthesize backgroundColor;
@synthesize textColor;
@synthesize textSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
    [self initTpaGesture];

    if (_attributedString) {
        self.textView.attributedText = _attributedString;
    }
}

-(void)initView{
    _textView = [[UITextView alloc] init];
    _toolbar = [[UIToolbar alloc] init];

    [self configureViews];

    [_toolbar setItems:[self getBarButtonItems]];

    _textView.editable = NO;

    [self.view addSubview:_textView];
    [self.view addSubview:_toolbar];

}

#pragma mark - barbuttonitem
-(NSArray *)getBarButtonItems{
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];

    UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *smallerFontButton = [[UIBarButtonItem alloc] initWithTitle:@"Font -" style:UIBarButtonItemStylePlain target:self action:@selector(smallerFontButtonClicked:)];

    UIBarButtonItem *flexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *biggerFontButton = [[UIBarButtonItem alloc] initWithTitle:@"Font +" style:UIBarButtonItemStylePlain target:self action:@selector(biggerFontButtonClicked:)];

    UIBarButtonItem *flexibleSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *backgroundColorSelectButton = [[UIBarButtonItem alloc] initWithTitle:@"Background Color" style:UIBarButtonItemStylePlain target:self action:@selector(backgroundColorSelectButtonClicked:)];

    return @[backBarButtonItem,flexibleSpace1,smallerFontButton,flexibleSpace2,biggerFontButton,flexibleSpace3,backgroundColorSelectButton];
}

-(void)back:(UIBarButtonItem *)backBarButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)smallerFontButtonClicked:(UIBarButtonItem *)barButtonItem{
    self.textSize--;
}

-(void)biggerFontButtonClicked:(UIBarButtonItem *)barButtonItem{
    self.textSize++;
}

-(void)backgroundColorSelectButtonClicked:(UIBarButtonItem *)barButtonItem{
    BackoundColorTableViewController *backgoundColor = [[BackoundColorTableViewController alloc] init];

    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:backgoundColor];

    self.popoverController.delegate = self;
    self.popoverController.popoverContentSize = backgoundColor.preferredContentSize;

    backgoundColor.readingModeViewController = self;

    [self.popoverController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

#pragma mark - tap gesture
-(void)initTpaGesture{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideToolbar:)];
    [self.textView addGestureRecognizer:tapGestureRecognizer];
}

-(void)showHideToolbar:(UITapGestureRecognizer *)tapGestureRecognizer{

    [self.toolbar setHidden:!self.toolbar.isHidden];
    
}


-(void)viewWillLayoutSubviews{
    self.view.backgroundColor = self.backgroundColor;

    [self configureViews];
}

-(void)configureViews{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    _textView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, screenWidth, screenHeight - STATUS_BAR_HEIGHT);

    _toolbar.frame = CGRectMake(0, screenHeight - TOOLBAR_HEIGHT , screenWidth,TOOLBAR_HEIGHT);
}

-(UIColor *)backgroundColor{
    if (!backgroundColor) {
        backgroundColor = [UIColor whiteColor];
    }
    return backgroundColor;
}

-(void)setBackgroundColor:(UIColor *)color{
    backgroundColor = color;
    self.view.backgroundColor = color;
    self.textView.backgroundColor = color;
}

-(UIColor *)textColor{
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    return textColor;
}

-(void)setTextColor:(UIColor *)color{
    textColor = color;
    self.textView.textColor = color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTextSize:(CGFloat)size{
    [self.attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size],
                                            NSForegroundColorAttributeName :textColor
                                            } range:NSMakeRange(0, self.attributedString.length)];

    self.textView.attributedText = self.attributedString;

    textSize = size;
}

-(CGFloat)textSize{
    if (!textSize) {
        textSize = 18;
    }
    return textSize;
}

@end
