//
//  IKWeekdayCell.h
//  BNTUSchedule
//
//  Created by Илья Кутеев on 28.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKScheduleCell.h"


@interface IKWeekdayCell : IKScheduleCell

@property (nonatomic) NSInteger weekday;

+(CGFloat)prefferedHeight;

@end
