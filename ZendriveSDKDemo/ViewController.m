//
//  ViewController.m
//  ZendriveSDKDemo
//
//  Created by Sumant Hanumante on 13/10/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import "ViewController.h"
#import <ZendriveSDK/Zendrive.h>
#import "Trip.h"
#import "LocationPoint.h"
#import <ZendriveSDK/ZendriveLocationPoint.h>
#import <ZendriveSDK/ZendriveTest.h>

static NSString * kZendriveKeyString = @"<your-sdk-key>";
static NSString * kDriverId = @"<your-driver-id>";

@interface ViewController () <ZendriveDelegateProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel* driveStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton* startDriveButton;
@property (nonatomic, weak) IBOutlet UIButton* endDriveButton;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic) BOOL isZendriveSetup;

@property (nonatomic, strong) NSMutableArray *tripsArray;

@end

@implementation ViewController

- init {
    self = [super initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _isZendriveSetup = NO;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.tripsArray = [self fetchAllTrips];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.isZendriveSetup) {
        [self initializeSDKWithSuccessHandler:^{
            // Will be called on main queue
            self.isZendriveSetup = YES;
            self.endDriveButton.enabled = YES;
            self.startDriveButton.enabled = YES;
            self.driveStatusLabel.text = @"Initialized successfully";
            NSLog(@"Initialized successfully");
        } andFailureHandler:^(NSError *err) {
            // Will be called on main queue
            self.driveStatusLabel.text =
            [NSString stringWithFormat:@"Failed to initialize zendrive :%@",
             err.localizedFailureReason];
            NSLog(@"Failed to initialize zendrive :%@", err.localizedFailureReason);
        }];
    }
}

#pragma mark UIButtonActions

- (IBAction)startDriveTapped:(id)sender {
    [Zendrive startDrive:@"your-tracking-id-here"];

    // Uncomment to test accident detection integration. Note that accident detection mode
    // should be set to ZendriveAccidentDetectionModeEnabled in the configuration during
    // setup.
    // [ZendriveTest raiseMockAccident:ZendriveAccidentConfidenceHigh];
}

- (IBAction)endDriveTapped:(id)sender {
    [Zendrive stopDrive:@"your-tracking-id-here"];
}

#pragma mark - Zendrive setup helper

- (void)initializeSDKWithSuccessHandler:(void (^)(void))successBlock
                      andFailureHandler:(void (^)(NSError *))failureBlock {
    ZendriveConfiguration *configuration = [[ZendriveConfiguration alloc] init];
    configuration.applicationKey = kZendriveKeyString;
    configuration.driverId = kDriverId;
    configuration.operationMode = ZendriveOperationModeDriverAnalytics;
    configuration.driveDetectionMode = ZendriveDriveDetectionModeAutoON;

    // Please contact support@zendrive.com to if you wish to enable this service for your application.
    configuration.accidentDetectionMode = ZendriveAccidentDetectionModeDisabled;

    [Zendrive
     setupWithConfiguration:configuration delegate:self
     completionHandler:^(BOOL success, NSError *error) {
         if(success) {
             successBlock();
         } else {
             failureBlock(error);
         }
     }];
}

#pragma mark - Zendrive Delegate collbacks

- (void)processStartOfDrive:(ZendriveDriveStartInfo *)startInfo {
    NSLog(@"Drive started!!");
    self.driveStatusLabel.text = @"Driving";
}

- (void)processEndOfDrive:(ZendriveDriveInfo *)drive {
    NSLog(@"Drive finished!!");
    self.driveStatusLabel.text = @"Drive Ended";
    if (drive.isValid) {

        Trip *trip = [self tripFromZendriveDriveInfo:drive];
        [self saveTrip:trip];
        [self.tripsArray insertObject:trip atIndex:0];
        [self.tableView reloadData];

    } else {
        self.driveStatusLabel.text = @"Invalid trip";
    }
}

- (void)processLocationDenied {
    [Zendrive teardown];
    self.driveStatusLabel.text = @"Location denied";
}

- (void)processAccidentDetected:(ZendriveAccidentInfo *)accidentInfo {
    if (accidentInfo.confidence == ZendriveAccidentConfidenceHigh) {
        // Panic
        [[[UIAlertView alloc]
          initWithTitle:@"Accident!!!"
          message:@"Please respond if you are ok, we will send help if you don't respond for a min"
          delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    else {
        // Little panic
        [[[UIAlertView alloc]
          initWithTitle:@"Accident!!!"
          message:@"Please respond if you are ok, we will send help if you don't respond for 10 mins"
          delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (Trip *)tripFromZendriveDriveInfo:(ZendriveDriveInfo *)drive {
    Trip *trip = [[Trip alloc] init];
    trip.startDate = [NSDate dateWithTimeIntervalSince1970:(drive.startTimestamp/1000)];
    trip.endDate = [NSDate dateWithTimeIntervalSince1970:(drive.endTimestamp/1000)];
    trip.distance = drive.distance;
    trip.averageSpeed = drive.averageSpeed;

    NSMutableArray *waypointsArray = [[NSMutableArray alloc] init];
    for (ZendriveLocationPoint *zendriveLocationPoint in drive.waypoints) {
        LocationPoint *locationPoint = [[LocationPoint alloc] initWithLatitude:zendriveLocationPoint.latitude
                                                                     longitude:zendriveLocationPoint.longitude];
        [waypointsArray addObject:locationPoint];
    }
    trip.waypoints = waypointsArray;
    return trip;
}

#pragma mark - Saving and retrieving trips
#define kTripsUserDefaultsKey @"tripsArray"

- (void)saveTrip:(Trip *)trip {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tripDictionary = [trip toDictionary];
    NSArray *tripsArray = [userDefaults objectForKey:kTripsUserDefaultsKey];
    NSArray *newTripsArray;
    if (tripsArray == nil) {
        newTripsArray = @[tripDictionary];
    }
    else {
        newTripsArray = [tripsArray arrayByAddingObject:tripDictionary];
    }

    [userDefaults setObject:newTripsArray forKey:kTripsUserDefaultsKey];
    [userDefaults synchronize];
}

- (NSMutableArray *)fetchAllTrips {
    NSMutableArray *tripsArray = [[NSMutableArray alloc] init];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *tripDictionariesArray = [userDefaults objectForKey:kTripsUserDefaultsKey];
    for (NSDictionary *tripDictioanry in tripDictionariesArray) {
        Trip *trip = [[Trip alloc] initWithDictionary:tripDictioanry];
        [tripsArray insertObject:trip atIndex:0];
    }

    return tripsArray;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tripsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tripCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Trip *trip = [self.tripsArray objectAtIndex:indexPath.row];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, yyyy HH:mm"];
    cell.textLabel.text = [dateFormatter stringFromDate:trip.startDate];
    int duration = trip.endDate.timeIntervalSince1970 - trip.startDate.timeIntervalSince1970;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Meters, %i seconds", trip.distance, duration];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
