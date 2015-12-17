//
//  HelpViewController.m
//  Note
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (strong,nonatomic)UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.webView];

    [self loadPage];

}

-(void)loadPage{
    NSURL *url = [NSURL URLWithString:@"http://note.youdao.com/helpcenter/help.html"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:request];
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;//adjust screen , can scale
    }
    return _webView;
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
