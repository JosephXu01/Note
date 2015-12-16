//
//  NoteDao.h
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@class Note;

@interface NoteDao : NSObject

@property (strong,nonatomic) AppDelegate *appDelegate;

-(NSArray *)getAllNotes;
-(Note *)newNote;
-(void)deleteNote:(Note *)note;
-(void)updateNote;

@end
