//
//  IKTextFieldCell.m
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 29.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKTextFieldCell.h"
#import "Masonry.h"


@implementation IKTextFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithWhite:145.0/255.0 alpha:1.0];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.tintColor = [UIColor blackColor];
    [self.contentView addSubview:textField];
    _textField = textField;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(titleLabel.superview);
        make.centerY.equalTo(titleLabel.superview);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(textField.superview);
        make.rightMargin.equalTo(textField.superview);
        make.left.equalTo(titleLabel.mas_right).with.offset(4);
        make.bottomMargin.equalTo(textField.superview);
    }];
    
    return self;
}

@end
