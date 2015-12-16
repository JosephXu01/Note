//
//  NoteService.h
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteDao.h"

@interface NoteService : NSObject

@property (strong,nonatomic) NoteDao *noteDao;

-(NSArray *)getAllNotes;
-(Note *)newNote;
-(void)updateNote;
-(void)deleteNote:(Note *)note;

@end
