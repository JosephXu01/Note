//
//  MoreActionTableViewController.h
//  Note
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import "Note.h"

#define NOTE_DELETED_FROM_EDIT_PAGE @"NoteDeletedFromEditPage"
#define NOTE_TO_DELETE @"NoteToDelete"

@interface MoreActionTableViewController : UITableViewController

@property (strong,nonatomic) EditViewController *editViewController;
@property (strong,nonatomic) Note *currentNote;

@end
