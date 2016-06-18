//
//  IKAddClassController.h
//  BNTUSchedule
//
//  Created by Илья Кутеев on 28.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

@import UIKit;
#import "IKScheduleController.h"


@interface IKAddClassController : UITableViewController
@property (nonatomic) NSInteger week;
@property (nonatomic) NSInteger weekday;
@property (nonatomic) NSString *group;
@property (nonatomic) IKScheduleType scheduleType;
@end
