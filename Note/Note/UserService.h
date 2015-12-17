//
//  NoteService.h
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDao.h"
#import "RegisterInfo.h"

@interface UserService : NSObject

@property (strong,nonatomic) UserDao *userDao;


-(User *)getUser;
-(void)newUserWithRegisterInfo:(RegisterInfo *)registerInfo;
-(User *)getUserByAccount:(NSString *)account andPassword:(NSString *)password;
-(NSString *)registerInfoCheck:(RegisterInfo *)registerInfo;
-(NSString *)loginInfoCheck:(NSString *)account andPassword:(NSString *)password;
-(void)updateUser;
-(NSString *)passwordCheckWithOriginalPass:(NSString *)originalPassword andFirstNewPass:(NSString *)firstNewPassword andSecondNewPass:(NSString *)secondNewPassword;
@end
