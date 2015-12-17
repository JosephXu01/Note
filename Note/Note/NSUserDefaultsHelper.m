//
//  DataHelper.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "NSUserDefaultsHelper.h"
#import "UserDao.h"

@implementation NSUserDefaultsHelper

+(NSUserDefaults *)userDefaults{
    return [NSUserDefaults standardUserDefaults];
}

+(void)synchronize{
    [[self userDefaults] synchronize];
}

+(NSString *)getUserAccount{
    return [[self userDefaults] valueForKey:ACCOUNT];
}

+(NSString *)getLoginPassword{
    return [[self userDefaults] valueForKey:LOGINPASSWORD];
}

+(NSString *)getUserName{
    return [[self userDefaults] valueForKey:NAME];
}

+(NSData *)getFaceImage{
    return [[self userDefaults] valueForKey:FACEIMAGE];
}

+(NSString *)getReadingPassword{
    return [[self userDefaults] valueForKey:READINGPASSWORD];
}

+(BOOL)isTouchIDUsed{
    return [[self userDefaults] valueForKey:ISTOUCHIDUSED];
}

+(void)setAccount:(NSString *)account andPassword:(NSString *)password andName:(NSString *)name andFaceImage:(NSData *)faceImage{
    [[self userDefaults] setValue:account forKey:ACCOUNT];
    [[self userDefaults] setValue:password forKey:LOGINPASSWORD];
    [[self userDefaults] setValue:name forKey:NAME];
    [[self userDefaults] setObject:faceImage forKey:FACEIMAGE];

    [self synchronize];
}

+(void)setFaceImage:(NSData *)faceImage{
    [[self userDefaults] setObject:faceImage forKey:FACEIMAGE];
    [self synchronize];
}

+(void)setIsTouchIDUsed:(BOOL)isTouchIdUsed{
    [[self userDefaults] setBool:isTouchIdUsed forKey:ISTOUCHIDUSED];
    [self synchronize];
}

+(void)setLoginPassword:(NSString *)loginPassword{
    [[self userDefaults] setValue:loginPassword forKey:LOGINPASSWORD];
    [self synchronize];
}

+(void)setReadingPassword:(NSString *)readingPassword{
    [[self userDefaults] setValue:readingPassword forKey:READINGPASSWORD];
    [self synchronize];
}

+(void)removeAccount{
    [[self userDefaults] removeObjectForKey:ACCOUNT];
    [[self userDefaults] removeObjectForKey:LOGINPASSWORD];
    [[self userDefaults] removeObjectForKey:READINGPASSWORD];
    [[self userDefaults] removeObjectForKey:ISTOUCHIDUSED];
    [[self userDefaults] removeObjectForKey:FACEIMAGE];

    [self synchronize];
}

+(void)removeIsTouchIDUsed{
    [[self userDefaults] removeObjectForKey:ISTOUCHIDUSED];
    [self synchronize];
}

+(void)removeReadingPassword{
    [[self userDefaults] removeObjectForKey:READINGPASSWORD];
    [self synchronize];
}

@end
