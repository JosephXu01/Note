//
//  TextFieldTableViewCell.h
//  Note
//
//  Created by Shallong on 15/12/15.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong,nonatomic) UITextField *textField;
@end
