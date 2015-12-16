//
//  NoteService.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "NoteService.h"
#import "Note.h"

@implementation NoteService

-(NSArray *)getAllNotes{
    return [self.noteDao getAllNotes];
}

-(Note *)newNote{
    return [self.noteDao newNote];
}

-(void)updateNote{
    [self.noteDao updateNote];
}

-(void)deleteNote:(Note *)note{
    [self.noteDao deleteNote:note];
}

-(NoteDao *)noteDao{
    if (!_noteDao) {
        _noteDao = [[NoteDao alloc] init];
    }
    return _noteDao;
}
@end
