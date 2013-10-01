//
//  CoreDataEngine.h
//  LocationApp
//
//  Created by Mihails Prihodko on 6/25/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#include "CoreDataDefines.h"
#import <Foundation/Foundation.h>

@interface CoreDataEngine : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext          *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel            *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

- (void)saveContext;

+ (CoreDataEngine *)sharedInstance;

@end
