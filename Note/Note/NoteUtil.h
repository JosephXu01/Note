//
//  NoteUtil.h
//  Note
//
//  Created by Shallong on 15/12/15.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MAIN @"Main"
#define LOGIN @"Login"


@interface NoteUtil : NSObject

+(UIAlertController *)okButtonAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)messages;
+(UIAlertController *)okButtonAlertControllerWithWarningTitleAndMessage:(NSString *)messages;

+(id)jumpToView:(NSString *)viewId;
+(id)jumpToViewWithStoryboardID:(NSString *)storyboardId andViewID:(NSString *)viewId;

@end
