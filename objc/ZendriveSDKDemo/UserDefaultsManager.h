//
//  UserDefaultsManager.h
//  ZendriveSDKDemo
//
//  Created by Yogesh on 4/11/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZendriveSDK/Zendrive.h>

#define SharedUserDefaultsManager [UserDefaultsManager sharedInstance]

@class User, Trip, Company, UserStatistics;
@interface UserDefaultsManager : NSObject

//------------------------------------------------------------------------------

+ (instancetype)sharedInstance;

//------------------------------------------------------------------------------

- (User *)loggedInUser;
- (void)setLoggedInUser:(User *)user;

- (ZendriveDriveDetectionMode)driveDetectionMode;
- (void)setDriveDetectionMode:(ZendriveDriveDetectionMode)driveDetectionMode;

- (int)serviceTier;
- (void)setServiceTier:(int)serviceTier;

//------------------------------------------------------------------------------
#pragma mark - Trip load/save
//------------------------------------------------------------------------------
- (void)saveTrip:(Trip *)trip;
- (void)updateTrip:(Trip *)trip;
- (NSMutableArray *)fetchAllTrips;

//------------------------------------------------------------------------------
@end
