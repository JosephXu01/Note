//
//  NoteDao.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "UserDao.h"
#import "User.h"
#import "RegisterInfo.h"
#import "NSUserDefaultsHelper.h"

#define USER @"User"

@implementation UserDao

-(AppDelegate *)appDelegate{
    if (!_appDelegate) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

-(User *)getUser{
    NSString *account = [NSUserDefaultsHelper getUserAccount];

    return [self getUserByAccount:account];
}

-(void)newUserWithRegisterInfo:(RegisterInfo *)registerInfo{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:USER inManagedObjectContext:self.appDelegate.managedObjectContext];

    user.nickName = registerInfo.nickName;
    user.loginAccount = registerInfo.account;
    user.loginPassword = registerInfo.password;

    [self.appDelegate saveContext];
}

-(User *)getUserByAccount:(NSString *)account{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"loginAccount = %@",account];

    request.predicate = predicate;

    NSError *error;

    NSArray *array = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"failed to retrive user! Error: %@!",error.localizedDescription);
    }

    return [array firstObject];
}

-(User *)getUserByAccount:(NSString *)account andPassword:(NSString *)password{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER];

    request.predicate = [NSPredicate predicateWithFormat:@"loginAccount = %@ AND loginPassword = %@",account,password];

    NSError *error;

    NSArray *array = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"failed to retrive user! Error: %@!",error.localizedDescription);
    }

    return [array firstObject];
}

-(void)updateUser{
    [self.appDelegate saveContext];
}

@end
