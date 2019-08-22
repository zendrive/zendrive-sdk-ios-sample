//
//  LocationPermissionUtility.m
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 22/08/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import "LocationPermissionUtility.h"
#import "AppDelegate.h"
#import "LocationPermissionViewController.h"

@implementation LocationNotificationConfiguration
- (instancetype)init {
    self = [super init];
    if (self) {
        _repeats = NO;
        _notificationTriggerDelay = 7 * 24 * 3600; // 7 days
        _notificationTitle = @"App is unable to record trips";
        _notificationDescription = @"Please grant Always Allow access for location.";
    }
    return self;
}
@end

@interface LocationPermissionUtility() <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLAuthorizationStatus authStatusUponAppLaunch;
@end

@implementation LocationPermissionUtility
__strong static LocationPermissionUtility *_sharedInstance = nil;
static NSString * const kPermissionScreenAlreadyPresentedKey = @"kPermissionScreenAlreadyPresentedKey";
static NSString * const kLocationNotificationAlreadyScheduledKey = @"kLocationNotificationAlreadyScheduledKey";
static NSString * const kZendriveLocationNotificationIdentifier = @"kZendriveLocationNotificationIdentifier";

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

+ (instancetype)sharedInstance {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
        return _sharedInstance;
    }
}

+ (void)initializeWithAuthStatus:(CLAuthorizationStatus)authStatusUponAppLaunch {
    [LocationPermissionUtility sharedInstance].authStatusUponAppLaunch = authStatusUponAppLaunch;
}

+ (void)showPermissionScreenIfNeeded {
    if (@available(iOS 13, *)) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kPermissionScreenAlreadyPresentedKey]) {
            return;
        } else {
            UIViewController *topViewController =
            (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UIViewController *parentViewController = topViewController;
            if (topViewController.presentedViewController) {
                parentViewController = topViewController.presentedViewController;
            }
            /// We will assume that the application has already requested
            /// permission and show the permissions screen.
            [[LocationPermissionUtility sharedInstance] presentPermissionsScreen:parentViewController];
        }
    }
}

+ (void)scheduleNotification:(LocationNotificationConfiguration *)configuration {
    if (@available(iOS 13, *)) {
        /// UNNotificationRequest with the same identifier will be automatically overwritten by the OS.
        /// Please note that calling UNUserNotificationCenter.removeAllPendingNotificationRequests()
        /// will not deliver this notification.
        if ((![[NSUserDefaults standardUserDefaults] boolForKey:kLocationNotificationAlreadyScheduledKey]) || (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways)) {
            [LocationPermissionUtility scheduleNotificationWithIdentifier:kZendriveLocationNotificationIdentifier
                                                            configuration:configuration];
        }
    }
}

+ (BOOL)handleNotification:(UNNotification *)notification {
    if (@available(iOS 13, *)) {
        if ([notification.request.identifier isEqualToString:kZendriveLocationNotificationIdentifier] && CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]
                 openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            });
            return YES;
        }
    }
    return NO;
}

//------------------------------------------------------------------------------
#pragma mark - Schedule Notification
//------------------------------------------------------------------------------
+ (void)scheduleNotificationWithIdentifier:(NSString *)identifier
                             configuration:(LocationNotificationConfiguration *)configuration {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    [content setTitle:configuration.notificationTitle];
    [content setBody:configuration.notificationDescription];

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:configuration.notificationTriggerDelay
                                                  repeats:configuration.repeats];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kLocationNotificationAlreadyScheduledKey];
}

//------------------------------------------------------------------------------
#pragma mark - ViewController display handling
//------------------------------------------------------------------------------
- (void)presentPermissionsScreen:(UIViewController *)presentingViewController {
    UIViewController *permissionViewController = [[LocationPermissionViewController alloc] init];
    [presentingViewController presentViewController:permissionViewController
                                           animated:YES
                                         completion:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kPermissionScreenAlreadyPresentedKey];
}

//------------------------------------------------------------------------------
#pragma mark - CLLocationManagerDelegate methods
//------------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            if (self.authStatusUponAppLaunch == kCLAuthorizationStatusNotDetermined) {
                [LocationPermissionUtility showPermissionScreenIfNeeded];
            }
            break;
        case kCLAuthorizationStatusNotDetermined:
            break;
    }
}
@end
