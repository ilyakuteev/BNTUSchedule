//
//  IKSchedule.h
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

@import CoreData;


#define IKSchedule [IKSchedule_ sharedInstanse]

@interface IKSchedule_ : NSObject

+(instancetype)sharedInstanse;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)save;

@end
