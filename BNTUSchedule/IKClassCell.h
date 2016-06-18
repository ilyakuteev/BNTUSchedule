//
//  IKClassCell.h
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKScheduleCell.h"
#import "IKClass.h"


@interface IKClassCell : IKScheduleCell
@property (nonatomic) IKClass *ik_class;
@end
