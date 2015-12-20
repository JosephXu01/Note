//
//  NoteUtil.m
//  Note
//
//  Created by Shallong on 15/12/15.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "NoteUtil.h"

@implementation NoteUtil

+(UIAlertController *)okButtonAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)messages{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messages preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];

    return alertController;
}

+(UIAlertController *)okButtonAlertControllerWithWarningTitleAndMessage:(NSString *)messages{
    return [self okButtonAlertControllerWithTitle:@"Warning" withMessage:messages];
}

+(id)jumpToView:(NSString *)viewId{
    return [self jumpToViewWithStoryboardID:viewId andViewID:viewId];
}

+(id)jumpToViewWithStoryboardID:(NSString *)storyboardId andViewID:(NSString *)viewId{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardId bundle:[NSBundle mainBundle]];
    id view = [storyboard instantiateViewControllerWithIdentifier:viewId];

    return view;
}

@end
