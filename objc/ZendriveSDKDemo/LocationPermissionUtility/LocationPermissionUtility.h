//
//  LocationPermissionUtility.h
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 22/08/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationNotificationConfiguration : NSObject
@property (nonatomic) BOOL repeats;
@property (nonatomic) long long notificationTriggerDelay;
@property (nonatomic) NSString *notificationTitle;
@property (nonatomic) NSString *notificationDescription;
@end

@interface LocationPermissionUtility : NSObject <CLLocationManagerDelegate>
+ (void)initializeWithAuthStatus:(CLAuthorizationStatus)authStatusUponAppLaunch;
+ (void)scheduleNotification:(LocationNotificationConfiguration *)configuration;
+ (BOOL)handleNotification:(UNNotification *)notification;
@end

NS_ASSUME_NONNULL_END
