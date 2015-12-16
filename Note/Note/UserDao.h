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

@class RegisterInfo;
@class User;

@interface UserDao : NSObject

@property (strong,nonatomic) AppDelegate *appDelegate;

-(User *)getUser;
-(void)newUserWithRegisterInfo:(RegisterInfo *)registerInfo;
-(User *)getUserByAccount:(NSString *)account;
-(User *)getUserByAccount:(NSString *)account andPassword:(NSString *)password;
-(void)updateUser;
@end
