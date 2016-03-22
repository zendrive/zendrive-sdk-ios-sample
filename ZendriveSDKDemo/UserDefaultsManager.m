//
//  UserDefaultsManager.m
//  ZendriveSDKDemo
//
//  Created by Yogesh on 4/11/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "UserDefaultsManager.h"
#import "User.h"
#import "Trip.h"

#define UserDefaults [NSUserDefaults standardUserDefaults]

static NSString *kLoggedInUserKey = @"loggedInUser";
static NSString *kDriveDetectionModeKey = @"driveDetectionMode";
static NSString *kServiceTierKey = @"serviceTier";
static NSString *kTripsUserDefaultsKey = @"tripsArray";
static UserDefaultsManager *_sharedInstance;

@implementation UserDefaultsManager

+ (instancetype)sharedInstance {
    if (_sharedInstance == nil) {
        @synchronized (self) {
            if (_sharedInstance == nil) {
                _sharedInstance = [[self alloc] init];
            }
        }
    }
    return _sharedInstance;
}

//------------------------------------------------------------------------------
#pragma mark - Logged In User
//------------------------------------------------------------------------------
- (void)setLoggedInUser:(User *)user {
    [UserDefaults setObject:user.toDictionary forKey:kLoggedInUserKey];
    [UserDefaults synchronize];
}

- (User *)loggedInUser {
    NSDictionary *userDictionary = [UserDefaults objectForKey:kLoggedInUserKey];
    if (userDictionary) {
        return [[User alloc] initWithDictionary:userDictionary];
    }
    return nil;
}

//------------------------------------------------------------------------------
#pragma mark - Drive detection mode
//------------------------------------------------------------------------------
- (void)setDriveDetectionMode:(ZendriveDriveDetectionMode)driveDetectionMode {
    [UserDefaults setObject:@(driveDetectionMode) forKey:kDriveDetectionModeKey];
    [UserDefaults synchronize];
}

- (ZendriveDriveDetectionMode)driveDetectionMode {
    NSNumber *driveDetectionModeNsNum = [UserDefaults objectForKey:kDriveDetectionModeKey];
    if (driveDetectionModeNsNum) {
        return driveDetectionModeNsNum.intValue;
    }
    return ZendriveDriveDetectionModeAutoON;
}

//------------------------------------------------------------------------------
#pragma mark - Service Tier
//------------------------------------------------------------------------------
- (void)setServiceTier:(int)serviceTier {
    [UserDefaults setObject:@(serviceTier) forKey:kServiceTierKey];
    [UserDefaults synchronize];
}

- (int)serviceTier {
    NSNumber *serviceTierNsNum = [UserDefaults objectForKey:kServiceTierKey];
    if (serviceTierNsNum) {
        return serviceTierNsNum.intValue;
    }
    return ZendriveServiceLevelDefault;
}

//------------------------------------------------------------------------------
#pragma mark - Saving and retrieving trips
//------------------------------------------------------------------------------
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
@end
