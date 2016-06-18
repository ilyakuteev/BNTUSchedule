//
//  IKSchedule.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKSchedule.h"

@implementation IKSchedule_

#pragma mark - Initialization

+(instancetype)sharedInstanse
{
    static IKSchedule_ *sharedInstanse;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanse = [[IKSchedule_ alloc] init];
    });
    return sharedInstanse;
}

#pragma mark - Core Data Stack

@synthesize managedObjectModel=_managedObjectModel;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

-(NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}


-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc performBlockAndWait:^{
            moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
        }];
            
        _managedObjectContext = moc;
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
    }
    
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        
        NSError *error;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:[self storeURL]
                                                        options:@{
                                                                  NSInferMappingModelAutomaticallyOption : @YES,
                                                                  NSMigratePersistentStoresAutomaticallyOption : @YES
                                                                  } error:&error];
        if (error) {
            NSLog(@"%@", error);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

-(NSURL *)storeURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    return [documentsURL URLByAppendingPathComponent:@"Schedule.sqlite"];
}

#pragma mark - 

-(void)save
{
    if (self.managedObjectContext.hasChanges) {
        NSError *error;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
}

@end
