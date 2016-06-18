//
//  IKClass.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKClass.h"


@implementation IKClass

-(IKClassType)type
{
    return self.type_.integerValue;
}

-(void)setType:(IKClassType)type
{
    self.type_ = @(type);
}

-(IKClassSubgroup)subgroup
{
    return self.subgroup_.integerValue;
}

-(void)setSubgroup:(IKClassSubgroup)subgroup
{
    self.subgroup_ = @(subgroup);
}

@end
