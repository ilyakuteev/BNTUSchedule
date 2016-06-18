//
//  IKTimeCell.m
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 29.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKTimeCell.h"
#import "Masonry.h"


@implementation IKTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 8;
    self.startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    components.hour = 9;
    components.minute = 35;
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    UILabel *startDateLabel = [[UILabel alloc] init];
    startDateLabel.text = @"Начало:";
    [self.contentView addSubview:startDateLabel];
    
    UILabel *endDateLabel = [[UILabel alloc] init];
    endDateLabel.text = @"Конец:";
    [self.contentView addSubview:endDateLabel];
    
    UIDatePicker *startDatePicker = [[UIDatePicker alloc] init];
    startDatePicker.datePickerMode = UIDatePickerModeTime;
    startDatePicker.date = self.startDate;
    startDatePicker.minuteInterval = 5;
    [startDatePicker addTarget:self action:@selector(startDateChanged) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:startDatePicker];
    _startDatePicker = startDatePicker;
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc] init];
    endDatePicker.datePickerMode = UIDatePickerModeTime;
    endDatePicker.date = endDate;
    endDatePicker.minuteInterval = 5;
    [startDatePicker addTarget:self action:@selector(updateDateLimits) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:endDatePicker];
    _endDatePicker = endDatePicker;
    
    [self updateDateLimits];
    
    [startDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startDateLabel.superview);
        make.left.equalTo(startDatePicker).with.offset(8);
    }];
    
    [endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endDateLabel.superview);
        make.left.equalTo(endDatePicker).with.offset(8);
    }];
    
    [startDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(startDateLabel.mas_bottom);
        make.left.equalTo(startDatePicker.superview);
        make.right.equalTo(startDatePicker.superview.mas_centerX);
    }];
    
    [endDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(startDateLabel.mas_bottom);
        make.right.equalTo(startDatePicker.superview);
        make.left.equalTo(startDatePicker.superview.mas_centerX);
    }];
    
    return self;
}

#pragma mark - Getters&Setters

-(void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    self.startDatePicker.date = startDate;
}

-(void)setEndDate:(NSDate *)endDate
{
    self.endDatePicker.date = endDate;
}

-(NSDate *)endDate
{
    return self.endDatePicker.date;
}

-(void)startDateChanged
{
    NSTimeInterval delta = [self.startDatePicker.date timeIntervalSinceDate:self.startDate];
    self.endDatePicker.date = [self.endDatePicker.date dateByAddingTimeInterval:delta];
    self.startDate = self.startDatePicker.date;
    
    [self updateDateLimits];
}

-(void)updateDateLimits
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 23;
    components.minute = 55;
    NSDate *dayEnd = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    self.startDatePicker.maximumDate = dayEnd;
    self.endDatePicker.maximumDate = dayEnd;
    self.endDatePicker.minimumDate = self.startDatePicker.date;
    
    if ([self.delegate respondsToSelector:@selector(timeCellTimeChanged:)]) {
        [self.delegate timeCellTimeChanged:self];
    }
}

@end
