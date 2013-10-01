//
//  Location.h
//  LocationApp
//
//  Created by Mihails Prihodko on 6/26/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSDate * timestamp;

@end
