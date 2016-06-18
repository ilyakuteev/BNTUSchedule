//
//  IKNoClassesCell.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 28.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKNoClassesCell.h"


@implementation IKNoClassesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.textLabel.text = @"Нет занятий";
    
    return self;
}

@end
