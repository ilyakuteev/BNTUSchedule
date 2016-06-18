//
//  IKTimeCell.h
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 29.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

@import UIKit;
@class IKTimeCell;


@protocol IKTimeCellDelegate <NSObject>
@optional
-(void)timeCellTimeChanged:(IKTimeCell *)timeCell;
@end


@interface IKTimeCell : UITableViewCell

@property (nonatomic, weak) id<IKTimeCellDelegate> delegate;

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic, readonly, weak) UIDatePicker *startDatePicker;
@property (nonatomic, readonly, weak) UIDatePicker *endDatePicker;

@end
