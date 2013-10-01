//
//  MPViewController.h
//  LocationApp
//
//  Created by Mihails Prihodko on 6/20/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate <NSObject>

- (void)didStartButtonPressed;
- (void)didStopButtonPressed;
- (void)didPurgeDataBaseButtonPressed;

@end

@interface MPViewController : UIViewController <SettingsDelegate>

- (void)applicationDidEnterBackground;
- (void)applicationDidBecomeActive;

@end
