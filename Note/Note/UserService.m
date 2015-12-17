//
//  NoteService.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "UserService.h"
#import "NSUserDefaultsHelper.h"
#import "User.h"

@implementation UserService

-(User *)getUser{
    return [self.userDao getUser];
}

-(void)updateUser{
    [self.userDao updateUser];
}

-(User *)getUserByAccount:(NSString *)account andPassword:(NSString *)password{
    if ([self isBlank:account] || [self isBlank:password]) {
        return nil;
    }
    return [self.userDao getUserByAccount:account andPassword:password];
}

-(void)newUserWithRegisterInfo:(RegisterInfo *)registerInfo{
    [self.userDao newUserWithRegisterInfo:registerInfo];
}

-(NSString *)registerInfoCheck:(RegisterInfo *)registerInfo{
    //blank check
    if ([self isBlank:registerInfo.nickName] || [self isBlank:registerInfo.account] || [self isBlank:registerInfo.password]) {
        return @"Please input all the infomation!";
    }

    //TODO:verify the value

    //account unique check
    if ([self.userDao getUserByAccount:registerInfo.account]) {
        return @"The account is already existes, please try to login directly or change an account!";
    }

    return nil;
}

-(NSString *)loginInfoCheck:(NSString *)account andPassword:(NSString *)password{

    //blank check
    if ([self isBlank:account] ||[self isBlank:password]) {
        return @"Please input all the infomation!";
    }

    //account check
    if (![self.userDao getUserByAccount:account]) {
        return @"The account doexn't exist!";
    }

    if (![self getUserByAccount:account andPassword:password]) {
        return @"The password doesn't match the account!";
    }

    return nil;
}

-(NSString *)passwordCheckWithOriginalPass:(NSString *)originalPassword andFirstNewPass:(NSString *)firstNewPassword andSecondNewPass:(NSString *)secondNewPassword{
    if ([self isBlank:originalPassword] ||[self isBlank:firstNewPassword] || [self isBlank:secondNewPassword]) {
        return @"Please input all the infomation!";
    }

    if (![firstNewPassword isEqualToString:secondNewPassword]) {
        return @"Please make sure the new passwords are the same!";
    }


    User *user = [self getUser];
    if (![user.loginPassword isEqualToString:originalPassword]) {
        return @"Please make sure the original password is correct!";
    }

    return nil;
}

-(BOOL)isBlank:(NSString *)str{
    //get rid of the whitespace
    if (!str || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }

}

-(UserDao *)userDao{
    if (!_userDao) {
        _userDao = [[UserDao alloc] init];
    }
    return _userDao;
}


@end
