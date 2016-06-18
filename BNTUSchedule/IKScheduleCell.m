//
//  IKTableViewCell.m
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 04.04.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKScheduleCell.h"
#import "Masonry.h"


@implementation IKScheduleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithWhite:232.0/255.0 alpha:1.0];
    [self.contentView addSubview:separator];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.right.equalTo(separator.superview);
        make.left.equalTo(separator.superview);
        make.bottom.equalTo(separator.superview);
    }];
    
    return self;
}

@end
