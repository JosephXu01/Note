//
//  NoteDao.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "NoteDao.h"
#import "Note.h"
#import "NSUserDefaultsHelper.h"
#import "User.h"
#import "UserDao.h"


#define NOTE @"Note"

@implementation NoteDao

-(AppDelegate *)appDelegate{
    if (!_appDelegate) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

-(NSArray *)getAllNotes{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NOTE];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastModifiedDate" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];

    NSString *account = [NSUserDefaultsHelper getUserAccount];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.loginAccount = %@",account];
    request.predicate = predicate;

    NSError *error;

    NSArray *array = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"failed to retrive note! Error: %@!",error.localizedDescription);
    }

    return array;
}

-(Note *)newNote{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:NOTE inManagedObjectContext:self.appDelegate.managedObjectContext];

    note.title = @"title";
    note.createdDate = [NSDate date];
    note.lastModifiedDate = [NSDate date];

    UserDao *userDao = [[UserDao alloc] init];
    note.user = [userDao getUser];

    [self.appDelegate saveContext];

    return note;
}

-(void)updateNote{

    [self.appDelegate saveContext];

}

-(void)deleteNote:(Note *)note{
    [self.appDelegate.managedObjectContext deleteObject:note];

    [self.appDelegate saveContext];

}
@end
