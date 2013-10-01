//
//  MPAppDelegate.h
//  LocationApp
//
//  Created by Mihails Prihodko on 6/20/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPViewController;
@class CoreDataEngine;

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MPViewController  *viewController;
@property (strong, nonatomic) CoreDataEngine    *coreDataEngine;

@end
