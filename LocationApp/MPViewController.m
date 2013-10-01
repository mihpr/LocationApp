//
//  MPViewController.m
//  LocationApp
//
//  Created by Mihails Prihodko on 6/20/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import "MPViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "TestCustomAnnotationView.h"
#import "SettingsVC.h"
#import "Location.h"

#define REUSABLE_ANNOTATION_ID                  @"annotationId"

@interface MPViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager             *locationManager;
@property (strong, nonatomic) CLLocation                    *latestLocation;
@property (strong, nonatomic) NSMutableArray                *locationHistory;
@property (strong, nonatomic) CLHeading                     *currentHeading;

@property (weak, nonatomic) IBOutlet UILabel                *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel                *headingLabel;
@property (weak, nonatomic) IBOutlet MKMapView              *mapView;
@property (weak, nonatomic) IBOutlet UIButton               *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel                *multitascingInicator;
@property (weak, nonatomic) IBOutlet UISwitch               *updatesSwith;

@property (strong, nonatomic) SettingsVC                    *settingsVC;

@property (strong, nonatomic) id <MKAnnotation>             testAnnotaton;
@property (strong, nonatomic) NSMutableArray                *coordinate2dArray;

@end

@implementation MPViewController

- (void)drawOverlayForLocation:(CLLocation *)location {
    MKPointAnnotation *testPointAnnotation = [[MKPointAnnotation alloc] init];
    [testPointAnnotation setCoordinate:location.coordinate];
    [self.mapView addAnnotation:testPointAnnotation];
}

- (void)drawLocationHistoryObjects {
//    self.coordinate2dArray = [NSMutableArray array];
    
    for (CLLocation *locationObject in self.locationHistory) {
        NSLog(@"locationObject: %@", locationObject);
        [self drawOverlayForLocation:locationObject];
        
    }
    
//    self.coordinate2dArray = [NSMutableArray array];
    
}

- (void)applicationDidEnterBackground {
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationDidBecomeActive {
    NSLog(@"applicationDidBecomeActive");
}

- (void)startUpdates {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Location services are disabled"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }
}

- (void)stopUpdates {
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = nil;
    annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:REUSABLE_ANNOTATION_ID];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:REUSABLE_ANNOTATION_ID];
    }
    
//    annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:REUSABLE_ANNOTATION_ID];
//    if (annotationView == nil) {
//        annotationView = [[TestCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:REUSABLE_ANNOTATION_ID];
//    }

    return annotationView;
}

#pragma mark - Multitasking indicator

- (void)setMultitaskingIndicator {
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }
    
    if (backgroundSupported) {
        self.multitascingInicator.backgroundColor = [UIColor greenColor];
    }
    else {
        self.multitascingInicator.backgroundColor = [UIColor redColor];
    }
}

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    NSLog(@"didUpdateLocations count: %u, last object: %@", [locations count], [locations lastObject]);
    self.latestLocation = [locations lastObject];
    self.locationLabel.text= self.latestLocation.description;
    [self.locationLabel sizeToFit];
    
    [self drawOverlayForLocation:self.latestLocation];
    [self saveLocationUpdate:self.latestLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.headingLabel.text = newHeading.description;
}

#pragma mark - Actions

- (IBAction)handeSettingsButton:(UIButton *)sender {
    [self openSettingsDialog];
}

- (void)openSettingsDialog {
    if (!self.settingsVC) {
        self.settingsVC = [[SettingsVC alloc] init];
    }
    self.settingsVC.delegate = self;
    self.settingsVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:self.settingsVC animated:YES completion:nil];
}

- (IBAction)handleUpdatesSwitch:(UISwitch *)sender {
    if (sender.on) {
        [self startUpdates];
    }
    else {
        [self stopUpdates];
    }
}

#pragma mark - Data base

- (void)saveLocationUpdate:(CLLocation *)locationToSave {
    NSManagedObjectContext *managedObjectContext = [CORE_DATA_ENGINE managedObjectContext];
    Location *locationManagedObject = [NSEntityDescription insertNewObjectForEntityForName:TABLE_LOCATIONS inManagedObjectContext:managedObjectContext];
    locationManagedObject.timestamp = locationToSave.timestamp;
    locationManagedObject.location = [NSKeyedArchiver archivedDataWithRootObject:locationToSave];
    [managedObjectContext save:nil];
    [self.locationHistory addObject:locationManagedObject];
}

- (void)loadLocationDataFromDatabase {
    NSManagedObjectContext *managedObjectContext = [CORE_DATA_ENGINE managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:TABLE_LOCATIONS inManagedObjectContext:managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];

    NSError *err;
    NSArray *locations = [managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    self.locationHistory = [NSMutableArray array];
    for (Location* managedLocationObject in locations) {
        CLLocation *locationObject = [NSKeyedUnarchiver unarchiveObjectWithData:managedLocationObject.location];
        [self.locationHistory addObject:locationObject];
    }
    NSLog(@"%u objects loaded from the database", [self.locationHistory count]);
}

- (void)purgeDatabase {
    NSManagedObjectContext *managedObjectContext = [CORE_DATA_ENGINE managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:TABLE_LOCATIONS inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *err;
    NSArray *locations = [managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    for (Location *location in locations) {
        [managedObjectContext deleteObject:location];
    }
    
    [managedObjectContext save:nil];
}

#pragma mark - Settings delegate

- (void)didStopButtonPressed {
    [self stopUpdates];
}

- (void)didStartButtonPressed {
    [self startUpdates];
}

- (void)didPurgeDataBaseButtonPressed {
    [self purgeDatabase];
    self.locationHistory = [NSMutableArray array];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setMultitaskingIndicator];
    [self loadLocationDataFromDatabase];
    [self drawLocationHistoryObjects];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
