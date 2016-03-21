//
//  SettingsViewController.m
//  ZendriveSDKDemo
//
//  Created by Yogesh on 2/26/16.
//  Copyright © 2016 Zendrive. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserDefaultsManager.h"

#import "NotificationConstants.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *driveDetectionModeChooser;
@property (nonatomic, weak) IBOutlet UISegmentedControl *serviceTierChooser;
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

- (IBAction)driveDetectionModeInfoButtonClicked:(id)sender {
    [[[UIAlertView alloc]
      initWithTitle:@"Drive Detection Mode"
      message:@"Choose AUTO ON if you want drives to be detected automatically in"
      " the application. This can be modified by calling [Zendrive setDriveDetectionMode:]"
      delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (IBAction)serviceTierInfoButtonClicked:(id)sender {
    [[[UIAlertView alloc]
      initWithTitle:@"Service Tier"
      message:@"If you have multiple service tier users in your application like "
      "Free/Paid users, contact us on support@zendrive.com to create "
      "special service plans"
      delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

@end
