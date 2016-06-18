//
//  IKScheduleController.h
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

@import UIKit;


typedef NS_ENUM(NSUInteger, IKScheduleType) {
    IKScheduleTypeClasses,
    IKScheduleTypeExams,
};

@interface IKScheduleController : UITableViewController
-(instancetype)initWithType:(IKScheduleType)type;
@property (nonatomic, readonly) IKScheduleType type;
-(void)reloadAllData;
@end
