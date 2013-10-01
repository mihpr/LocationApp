//
//  Settings.m
//  LocationApp
//
//  Created by Mihails Prihodko on 6/25/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray           *pickerViewData;

@end

@implementation SettingsVC

#pragma mark - Picker View data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerViewData count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - Picker View delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerViewData[row];
}

#pragma mark - Button actions

- (IBAction)handleOkButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handlePurgeDatabaseButton:(UIButton *)sender {
    [self.delegate didPurgeDataBaseButtonPressed];
}

//- (IBAction)handleStartButton:(UIButton *)sender {
//    [self.delegate didStartButtonPressed];
//}
//
//- (IBAction)handleStopButton:(UIButton *)sender {
//    [self.delegate didStopButtonPressed];
//}

#pragma mark - Lifecycle 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pickerViewData = @[@"Item 1", @"Item 2", @"Item 3"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
