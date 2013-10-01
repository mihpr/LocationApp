//
//  Settings.h
//  LocationApp
//
//  Created by Mihails Prihodko on 6/25/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPViewController.h"

@interface SettingsVC : UIViewController

@property (weak, nonatomic) id <SettingsDelegate>            delegate;

@end
