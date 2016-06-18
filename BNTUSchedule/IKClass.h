//
//  IKClass.h
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

@import Foundation;
@import CoreData;


typedef NS_ENUM(NSUInteger, IKClassType) {
    IKClassTypeLecture      = 0,
    IKClassTypePractice     = 1,
    IKClassTypeLaboratory   = 2,
    
    IKClassTypeСonsultation = 3,
    IKClassTypeCredit       = 4,
    IKClassTypeExam         = 5
};

typedef NS_ENUM(NSUInteger, IKClassSubgroup) {
    IKClassSubgroupFirst  = 0,
    IKClassSubgroupSecond = 1,
    IKClassSubgroupAll    = 2
};


@interface IKClass : NSManagedObject
@property (nonatomic) IKClassType type;
@property (nonatomic) IKClassSubgroup subgroup;
@end


#import "IKClass+CoreDataProperties.h"
