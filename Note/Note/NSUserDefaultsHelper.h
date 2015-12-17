//
//  DataHelper.h
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Note.h"

#define ACCOUNT @"account"
#define LOGINPASSWORD @"loginPassword"
#define NAME @"name"
#define FACEIMAGE @"faceImage"
#define ISTOUCHIDUSED @"isTouchIDUsed"
#define READINGPASSWORD @"readingPassword"

@interface NSUserDefaultsHelper : NSObject

+(NSUserDefaults *)userDefaults;
+(void)synchronize;

+(NSString *)getUserAccount;
+(NSString *)getLoginPassword;
+(NSString *)getUserName;
+(NSData *)getFaceImage;
+(NSString *)getReadingPassword;
+(BOOL)isTouchIDUsed;

+(void)setAccount:(NSString *)account andPassword:(NSString *)password andName:(NSString *)name andFaceImage:(NSData *)faceImage;
+(void)setLoginPassword:(NSString *)loginPassword;
+(void)setReadingPassword:(NSString *)readingPassword;
+(void)setFaceImage:(NSData *)faceImage;
+(void)setIsTouchIDUsed:(BOOL)isTouchIdUsed;

+(void)removeAccount;
+(void)removeReadingPassword;
+(void)removeIsTouchIDUsed;


@end
