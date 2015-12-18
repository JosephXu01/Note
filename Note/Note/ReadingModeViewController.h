//
//  ReadingModeViewController.h
//  Note
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
@class Note;

@interface ReadingModeViewController : UIViewController <WEPopoverControllerDelegate>

@property (strong,nonatomic) NSMutableAttributedString *attributedString;

@property (strong,nonatomic) WEPopoverController *popoverController;

@property (strong,nonatomic) UIColor *backgroundColor;
@property (strong,nonatomic) UIColor *textColor;


@end
