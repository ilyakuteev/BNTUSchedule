//
//  IKClass+CoreDataProperties.h
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 08.04.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IKClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface IKClass (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *classroom;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSString *housing;
@property (nullable, nonatomic, retain) NSString *lecturer;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type_;
@property (nullable, nonatomic, retain) NSNumber *week;
@property (nullable, nonatomic, retain) NSNumber *weekday;
@property (nullable, nonatomic, retain) NSString *group;
@property (nullable, nonatomic, retain) NSNumber *subgroup_;

@end

NS_ASSUME_NONNULL_END
