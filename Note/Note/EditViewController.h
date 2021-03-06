//
//  EditViewController.h
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "WEPopoverController.h"

#define NOTE_UPDATED_NOTIFICATION @"NoteUpdatedNotification"
#define UPDATEDNOTE @"updatedNote"

@interface EditViewController : UIViewController <WEPopoverControllerDelegate>

@property (strong,nonatomic) Note *currentNote;
@property (strong,nonatomic) WEPopoverController *popoverController;

@end
