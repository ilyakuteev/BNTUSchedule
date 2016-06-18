//
//  IKWeekdayCell.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 28.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKWeekdayCell.h"
#import "Masonry.h"


@implementation IKWeekdayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"weekday_bg"];
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.backgroundView.contentMode = UIViewContentModeTopLeft;
    
    return self;
}

-(void)setWeekday:(NSInteger)weekday
{
    _weekday = weekday;
    
    weekday = weekday + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.textLabel.text = dateFormatter.weekdaySymbols[weekday];
}

+(CGFloat)prefferedHeight
{
    UIImage *backgroundImage = [UIImage imageNamed:@"weekday_bg"];
    return backgroundImage.size.height;
}

@end
