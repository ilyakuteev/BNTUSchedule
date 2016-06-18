//
//  IKClassCell.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKClassCell.h"
#import "Masonry.h"

#define IKClassCellTextColor [UIColor colorWithWhite:146.0/255.0 alpha:1.0]


@interface IKClassCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *classroomLabel;
@property (nonatomic, weak) UILabel *typeLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@end


@implementation IKClassCell

#pragma mark - Initialization

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.numberOfLines = 3;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 3;
    titleLabel.textColor = IKClassCellTextColor;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = IKClassCellTextColor;
    timeLabel.numberOfLines = 3;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.superview);
        make.bottom.equalTo(typeLabel.superview);
        make.left.equalTo(typeLabel.superview);
        make.width.equalTo(@30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.superview);
        make.bottom.equalTo(titleLabel.superview);
        make.left.equalTo(typeLabel.mas_right).with.offset(4);
        make.right.equalTo(timeLabel.mas_left).with.offset(4);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.superview);
        make.bottom.equalTo(timeLabel.superview);
        make.right.equalTo(timeLabel.superview).with.offset(-8);
        make.width.equalTo(@50);
    }];
    
    return self;
}

-(void)setIk_class:(IKClass *)ik_class
{
    _ik_class = ik_class;
    
    ik_class.title = ik_class.title ? ik_class.title : @"";
    ik_class.lecturer = ik_class.lecturer ? ik_class.lecturer : @"";
    ik_class.classroom = ik_class.classroom ? ik_class.classroom : @"";
    ik_class.housing = ik_class.housing ? ik_class.housing : @"";
    self.titleLabel.text = [@[ik_class.title, ik_class.lecturer,
                              [@[ik_class.classroom, ik_class.housing] componentsJoinedByString:@" "]] componentsJoinedByString:@"\n"];
    
    if (ik_class.type == IKClassTypeLecture) {
        self.typeLabel.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:179.0/255.0 blue:30.0/255.0 alpha:1.0];
        self.typeLabel.text = @"Л\nЕ\nК";
    } else if (ik_class.type == IKClassTypePractice) {
        self.typeLabel.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:187.0/255.0 blue:23.0/255.0 alpha:1.0];
        self.typeLabel.text = @"П\nР\nА";
    } else if (ik_class.type == IKClassTypeLaboratory) {
        self.typeLabel.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:23.0/255.0 blue:23.0/255.0 alpha:1.0];
        self.typeLabel.text = @"Л\nА\nБ";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    NSString *startDateString = [dateFormatter stringFromDate:ik_class.startDate];
    NSString *endDateString = [dateFormatter stringFromDate:ik_class.endDate];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\nдо\n%@", startDateString, endDateString];
}

@end
