//
//  TextFieldTableViewCell.m
//  Note
//
//  Created by Shallong on 15/12/15.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    // Initialization code

    }

//override
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textField.frame = CGRectMake(10, 0, self.frame.size.width, self.frame.size.height);
        self.textField.secureTextEntry = YES;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.returnKeyType = UIReturnKeyDone;

        [self addSubview:self.textField];

        self.textField.delegate = self;
    }
    return self;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
    }
    return _textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}




@end
