//
//  SettingsViewController.m
//  ZendriveSDKDemo
//
//  Created by Yogesh on 2/26/16.
//  Copyright © 2016 Zendrive. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserDefaultsManager.h"
#ifdef MOCK_BUILD
#import "MockDriveController.h"
#endif

#import "NotificationConstants.h"
#import "UserConsentUtility.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *driveDetectionModeChooser;
@property (nonatomic, weak) IBOutlet UISegmentedControl *serviceTierChooser;
@property (nonatomic, weak) IBOutlet UISegmentedControl *thirdPartyDataCollectionChooser;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    ZendriveDriveDetectionMode driveDetectionMode =
    [SharedUserDefaultsManager driveDetectionMode];
    [_driveDetectionModeChooser setSelectedSegmentIndex:driveDetectionMode];

    int serviceTier = [SharedUserDefaultsManager serviceTier];
    [_serviceTierChooser setSelectedSegmentIndex:serviceTier];

    BOOL thirdPartyPermission = [UserConsentUtility isThirdPartyDataCollectionAllowed];
    [self.thirdPartyDataCollectionChooser setSelectedSegmentIndex:(thirdPartyPermission ? 0 : 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [SharedUserDefaultsManager setLoggedInUser:nil];
    [NotificationCenter postNotificationName:kNotificationUserLogout object:nil];
}

- (IBAction)driveDetectionModeChooserValueChanged:(UISegmentedControl *)sender {
    [SharedUserDefaultsManager setDriveDetectionMode:(int)sender.selectedSegmentIndex];
    [NotificationCenter postNotificationName:kNotificationDriveDetectionModeUpdated object:nil];
}

- (IBAction)serviceTierChooserValueChanged:(UISegmentedControl *)sender {
    [SharedUserDefaultsManager setServiceTier:(int)sender.selectedSegmentIndex];
    [NotificationCenter postNotificationName:kNotificationServiceTierUpdated object:nil];
}

- (IBAction)thirdPartyDataCollectionValueChanged:(UISegmentedControl *)sender {
    [UserConsentUtility setAllowThirdPartyToCollectData:((int)sender.selectedSegmentIndex == 0)];
    [NotificationCenter postNotificationName:kNotificationThirdPartyDataCollectionPermissionUpdated object:nil];
}

- (IBAction)driveDetectionModeInfoButtonClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Drive Detection Mode"
                                          message:@"Choose AUTO ON if you want drives to be detected automatically"
                                                  " in the application. This can be modified by calling [Zendrive "
                                                  "setDriveDetectionMode:]"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleCancel
                                handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)serviceTierInfoButtonClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Service Tier"
                                          message:@"If you have multiple service tier users in your application"
                                                   "like Free/Paid users, contact us on support@zendrive.com "
                                                   "to create special service plans"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleCancel
                                handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)simulateDriveList:(id)sender {
#ifdef MOCK_BUILD
    MockDriveController *controller = [[MockDriveController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
#else
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Mock Drive not enabled"
                                          message:@"Simulate preset drives is not enabled in this build. Please"
                                                   "build Mock-ZendriveSDKDemo target to access this option."
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleCancel
                                handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
#endif
}

@end
