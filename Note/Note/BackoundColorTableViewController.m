//
//  BackoundColorTableViewController.m
//  Note
//
//  Created by Shallong on 15/12/18.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "BackoundColorTableViewController.h"
#define WHITE @"White"
#define GREEN @"Green"
#define BLACK @"Black"
enum{
    White,
    Green,
    Black,
}Colors;

@interface BackoundColorTableViewController ()
@property (strong,nonatomic) NSArray *colorsArray;


@end

@implementation BackoundColorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.colorsArray = @[WHITE,GREEN,BLACK];

    self.preferredContentSize = CGSizeMake(100, 44 * self.colorsArray.count - 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colorsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    cell.textLabel.text = self.colorsArray[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case White:
            self.readingModeViewController.backgroundColor = [UIColor whiteColor];
            self.readingModeViewController.textColor = [UIColor blackColor];
            break;
        case Green:
            self.readingModeViewController.backgroundColor = [UIColor greenColor];
            self.readingModeViewController.textColor = [UIColor blackColor];
            break;
        case Black:
            self.readingModeViewController.backgroundColor = [UIColor blackColor];
            self.readingModeViewController.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
}

@end
