//
//  ViewController.m
//  ZendriveSDKDemo
//
//  Created by Sumant Hanumante on 13/10/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import "ViewController.h"
#import "UserDefaultsManager.h"
#import "Trip.h"
#import "User.h"
#import "LocationPoint.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LocationPermissionUtility.h"
#import <ZendriveSDK/Zendrive.h>
#import <ZendriveSDK/ZendriveLocationPoint.h>
#import <ZendriveSDK/ZendriveTest.h>
#import <CoreLocation/CoreLocation.h>

#import "SettingsViewController.h"
#import "NotificationConstants.h"
#import "UserConsentUtility.h"

static NSString * kZendriveSDKKeyString = @"your-sdk-key";

@interface ViewController () <ZendriveDelegateProtocol, UITableViewDelegate, UITableViewDataSource, UserConsentViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel* driveStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton* startDriveButton;
@property (nonatomic, weak) IBOutlet UIButton* endDriveButton;
@property (nonatomic, weak) IBOutlet UIButton* mockAccidentButton;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UILabel *driverIdLabel;
@property (nonatomic) BOOL isZendriveSetup;

@property (nonatomic, strong) NSMutableArray *tripsArray;

@property (nonatomic, weak) IBOutlet UIView *loginView;
@property (nonatomic, weak) IBOutlet UITextField *driverIdField;
@property (nonatomic, weak) IBOutlet UISegmentedControl *operationModeChooser;
@end

@implementation ViewController

- (instancetype)init {
    self = [super initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _isZendriveSetup = NO;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.tripsArray = [SharedUserDefaultsManager fetchAllTrips];
    [self.tableView reloadData];
    [self registerForNotifications];
    if ([UserConsentUtility isConsentProvidedByTheUser] && [UserConsentUtility isThirdPartyDataCollectionAllowed]) {
        [self setupZendriveSdkAndReloadView];
    }
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupZendriveSdkAndReloadView {
    if (!self.isZendriveSetup) {
        User *user = [SharedUserDefaultsManager loggedInUser];
        if (!user) {
            // Display login
            self.loginView.hidden = NO;
            return;
        }
        self.driverIdLabel.text = user.driverId;
        self.loginView.hidden = YES;
        if (![UserConsentUtility isThirdPartyDataCollectionAllowed]) {
            self.endDriveButton.enabled = NO;
            self.startDriveButton.enabled = NO;
            self.driveStatusLabel.text = @"SDK Not Initialized";
            return;
        }
        CLAuthorizationStatus authStatusUponAppLaunch = [CLLocationManager authorizationStatus];
        [LocationPermissionUtility initializeWithAuthStatus:authStatusUponAppLaunch];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self initializeSDKForUser:user successHandler:
         ^{
             // Will be called on main queue
            self.isZendriveSetup = YES;
            self.endDriveButton.enabled = YES;
            self.startDriveButton.enabled = YES;
            self.driveStatusLabel.text = @"Initialized successfully";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LocationPermissionUtility scheduleNotification:[[LocationNotificationConfiguration alloc] init]];
         } andFailureHandler:^(NSError *err) {
            // Will be called on main queue
            self.driveStatusLabel.text =
            [NSString stringWithFormat:@"Failed to initialize zendrive :%@",
            err.localizedFailureReason];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Notification Handling
//------------------------------------------------------------------------------
- (void)registerForNotifications {
    [NotificationCenter addObserver:self selector:@selector(userLoggedOut:)
                               name:kNotificationUserLogout object:nil];
    [NotificationCenter addObserver:self selector:@selector(driveDetectionModeUpdated:)
                               name:kNotificationDriveDetectionModeUpdated object:nil];
    [NotificationCenter addObserver:self selector:@selector(serviceTierUpdated:)
                               name:kNotificationServiceTierUpdated object:nil];
    [NotificationCenter addObserver:self selector:@selector(thirdPartyDataCollectionPermissionUpdated:)
                               name:kNotificationThirdPartyDataCollectionPermissionUpdated object:nil];
}

- (void)userLoggedOut:(NSNotification *)notification {
    [Zendrive teardownWithCompletionHandler:nil];
    self.isZendriveSetup = NO;
    [self setupZendriveSdkAndReloadView];
}

- (void)driveDetectionModeUpdated:(NSNotification *)notification {
    ZendriveDriveDetectionMode driveDetectionMode =
    [SharedUserDefaultsManager driveDetectionMode];
    [Zendrive setDriveDetectionMode:driveDetectionMode
                  completionHandler:^(BOOL success, NSError * _Nullable error) {
                      if (success) {
                          NSLog(@"Drive detection mode successfully set to %d",driveDetectionMode);
                      } else {
                          NSLog(@"Failed to set drive detection mode with error code:%ld, description:%@",(long)error.code,error.description);
                      }
                  }];
}

- (void)serviceTierUpdated:(NSNotification *)notification {
    [Zendrive teardownWithCompletionHandler:nil];
    self.isZendriveSetup = NO;
    [self setupZendriveSdkAndReloadView];
}

- (void)thirdPartyDataCollectionPermissionUpdated:(NSNotification *)notification {
    // Consent Step: User has changed permissions for third-party data collection
    if ([UserConsentUtility isThirdPartyDataCollectionAllowed]) {
        // Choose to show the consent screen to the user and setup the SDK thereafter
        [UserConsentUtility showConsentScreenForCompanyName:@"ZendriveSDKDemo"
                                                   delegate:self
                                   presentingViewController:self];
    } else {
        // Tear down ZendriveSDK since user has disallowed third-party data collection
        [Zendrive teardownWithCompletionHandler:nil];
        self.isZendriveSetup = NO;
        [self setupZendriveSdkAndReloadView];
    }
}

//------------------------------------------------------------------------------
#pragma mark UIButtonActions
//------------------------------------------------------------------------------
- (IBAction)loginButtonTapped:(id)sender {
    NSString *driverId = self.driverIdField.text;
    if (driverId.length == 0 || ![Zendrive isValidInputParameter:driverId]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Oops!!"
                                              message:@"Please enter a valid driver-id"
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleCancel
                                    handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    [self.view endEditing:YES];
    User *user = [[User alloc] initWithFullName:@"FirstName LastName"
                                    phoneNumber:@"+1234567890"
                                       driverId:driverId];
    [SharedUserDefaultsManager setLoggedInUser:user];
    // Consent Step: Take consent from user
    [UserConsentUtility showConsentScreenForCompanyName:@"ZendriveSDKDemo"
                                               delegate:self
                               presentingViewController:self];
}

- (IBAction)startDriveTapped:(id)sender {
    [Zendrive startManualDrive:@"your-tracking-id-here"
             completionHandler:^(BOOL success, NSError * _Nullable error) {
                 if(success) {
                     NSLog(@"Manual Drive started");
                 } else {
                     NSLog(@"Start drive failed with error code: \
                           %ld and description:%@",(long)error.code,error.description);
                 }
    }];
}

- (IBAction)endDriveTapped:(id)sender {
    [Zendrive stopManualDrive:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"Drive stopped successfully");
        } else {
            NSLog(@"Stop drive failed with error code: \
                  %ld and description:%@",(long)error.code,error.description);
        }
    }];
}

- (IBAction)triggerMockAccidentTapped:(id)sender {
    // Following will trigger onAccidentDetected callback from ZendriveSDK, this
    // workflow will work just like a collision in a real world scenario and can
    // be used to test accident UX of your application.
    // Note that this will only work when ZendriveSDK is set up and there's an
    // active drive, accident detection mode should also be set to
    // ZendriveAccidentDetectionModeEnabled in the configuration during setup.
    [ZendriveTest raiseMockAccident:ZendriveAccidentConfidenceHigh];
}

- (IBAction)settingsButtonClicked:(id)sender {
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}

//------------------------------------------------------------------------------
#pragma mark - Zendrive setup helper
//------------------------------------------------------------------------------
- (void)initializeSDKForUser:(User *)user
              successHandler:(void (^)(void))successBlock
           andFailureHandler:(void (^)(NSError *))failureBlock {
    ZendriveConfiguration *configuration = [[ZendriveConfiguration alloc] init];
    configuration.applicationKey = kZendriveSDKKeyString;
    ZendriveDriveDetectionMode driveDetectionMode = [SharedUserDefaultsManager driveDetectionMode];
    configuration.driveDetectionMode = driveDetectionMode;

    configuration.driverId = user.driverId;
    // Please make sure that your application handles both
    // potential as well as final accident callbacks before
    // setting `implementsMultipleAccidentCallbacks` to true.
    configuration.implementsMultipleAccidentCallbacks = true;

    ZendriveDriverAttributes *driverAttrs = [[ZendriveDriverAttributes alloc] init];

    NSString *firstName = user.firstName;
    if (firstName.length > 0) {
        [driverAttrs setAlias:firstName];
    }

    ZendriveServiceLevel serviceLevel = [SharedUserDefaultsManager serviceTier];
    [driverAttrs setServiceLevel:serviceLevel];

    configuration.driverAttributes = driverAttrs;

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

//------------------------------------------------------------------------------
#pragma mark - Zendrive Delegate callbacks
//------------------------------------------------------------------------------
- (void)processStartOfDrive:(ZendriveDriveStartInfo *)startInfo {
    NSLog(@"Drive started!!");
    self.driveStatusLabel.text = @"Driving";

    if ([self isAccidentEnabled]) {
        self.mockAccidentButton.enabled = YES;
    }

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy, HH:mm";
    NSString *dateString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:
                                               (startInfo.startTimestamp/1000)]];
    [self displayNotification:[NSString stringWithFormat:@"Trip started: %@", dateString]];
}

- (void)processEndOfDrive:(ZendriveDriveInfo *)drive {
    NSLog(@"Drive finished!!");
    self.driveStatusLabel.text = @"Drive Ended";
    if ([self isAccidentEnabled]) {
        self.mockAccidentButton.enabled = NO;
    }

    Trip *trip = [self tripFromZendriveDriveInfo:drive];
    trip.tripStatus = @"Ended";
    [SharedUserDefaultsManager saveTrip:trip];
    [self.tripsArray insertObject:trip atIndex:0];
    [self.tableView reloadData];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy, HH:mm";
    NSString *startDateString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:
                                                    (drive.startTimestamp/1000)]];
    NSString *endDateString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:
                                                  (drive.endTimestamp/1000)]];
    [self displayNotification:
     [NSString stringWithFormat:@"Trip ended: %@, %@\nDistance: %.2fm",
      startDateString, endDateString, drive.distance]];
}

- (void)processAnalysisOfDrive:(ZendriveAnalyzedDriveInfo *)analyzedDriveInfo {
    NSLog(@"Drive analyzed!!");
    self.driveStatusLabel.text = @"Drive Analyzed";
    if ([self isAccidentEnabled]) {
        self.mockAccidentButton.enabled = NO;
    }

    Trip *trip = [self tripFromZendriveDriveInfo:analyzedDriveInfo];
    trip.tripStatus = @"Analyzed";
    [SharedUserDefaultsManager updateTrip:trip];
    self.tripsArray = [SharedUserDefaultsManager fetchAllTrips];
    [self.tableView reloadData];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy, HH:mm";
    NSString *startDateString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:
                                                    (analyzedDriveInfo.startTimestamp/1000)]];
    NSString *endDateString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:
                                                  (analyzedDriveInfo.endTimestamp/1000)]];
    [self displayNotification:
     [NSString stringWithFormat:@"Trip analyzed: %@, %@\nDistance: %.2fm",
      startDateString, endDateString, analyzedDriveInfo.distance]];
}

- (void)processLocationDenied {
    self.driveStatusLabel.text = @"Location denied";
}

- (void)processLocationApproved {
    if (self.isZendriveSetup) {
        self.driveStatusLabel.text = @"Location approved";
    }
}

- (void)processAccidentDetected:(ZendriveAccidentInfo *)accidentInfo {
    NSString *alertString;
    if (accidentInfo.confidence == ZendriveAccidentConfidenceHigh) {
        // Panic
        alertString = @"Please respond if you are ok, we will "
        "send help if you don't respond for a min";
        [self displayNotification:@"Accident Detected with high confidence."];
    }
    else {
        // Little panic
        alertString = @"Please respond if you are ok, we will send help "
        "if you don't respond for 10 mins";
        [self displayNotification:@"Accident Detected with low confidence."];
    }

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Accident!!!"
                                          message:alertString
                                          preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"I'm Ok."
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
         [ZendriveFeedback addEventOccurrenceWithDriveId:accidentInfo.driveId
                                          eventTimestamp:accidentInfo.timestamp
                                               eventType:ZendriveEventAccident
                                              occurrence:YES];

    }]];

    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"Please send help."
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
         [ZendriveFeedback addEventOccurrenceWithDriveId:accidentInfo.driveId
                                          eventTimestamp:accidentInfo.timestamp
                                               eventType:ZendriveEventAccident
                                              occurrence:YES];

    }]];

    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"Nothing happened."
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
         [ZendriveFeedback addEventOccurrenceWithDriveId:accidentInfo.driveId
                                          eventTimestamp:accidentInfo.timestamp
                                               eventType:ZendriveEventAccident
                                              occurrence:NO];

    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)processPotentialAccidentDetected:(ZendriveAccidentInfo *)accidentInfo {
    [self displayNotification:@"Potential accident detected!"];
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

//------------------------------------------------------------------------------
#pragma mark - UITableViewDatasource
//------------------------------------------------------------------------------
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Meters, %i seconds, %@",
                                 trip.distance, duration, trip.tripStatus];
    return cell;
}

//------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate
//------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)getDriverId {
    NSString *deviceName = [[UIDevice currentDevice] name];
    deviceName = [deviceName capitalizedString];
    deviceName = [[deviceName componentsSeparatedByCharactersInSet:
                   [[NSCharacterSet alphanumericCharacterSet] invertedSet]]
                  componentsJoinedByString:@""];

    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *driverId = [NSString stringWithFormat:@"%@-%@", bundleIdentifier, deviceName];
    return driverId;
}

//------------------------------------------------------------------------------
#pragma mark - Utils
//------------------------------------------------------------------------------
- (BOOL)isAccidentEnabled {
    return [Zendrive isAccidentDetectionSupportedByDevice];
}

- (void)displayNotification:(NSString *)message {
    UNMutableNotificationContent* notification = [[UNMutableNotificationContent alloc] init];
    notification.body = message;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"id"
                                                                          content:notification
                                                                          trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:nil];
}

//------------------------------------------------------------------------------
#pragma mark - UserConsentViewControllerDelegate
//------------------------------------------------------------------------------
// Consent Step: User has granted consent. Setup Zendrive SDK here.
- (void)userDidGrantConsent {
    [self setupZendriveSdkAndReloadView];
}

- (void)displayPrivacyPolicyScreen {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.zendrive.com/policy/"]
                                       options:@{}
                             completionHandler:nil];
}

@end
