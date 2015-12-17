//
//  EditViewController.h
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

#define NOTEUPDATEDNOTIFICATION @"NoteUpdatedNotification"
#define UPDATEDNOTE @"updatedNote"

@interface EditViewController : UIViewController 

@property (strong,nonatomic) Note *currentNote;

@end
