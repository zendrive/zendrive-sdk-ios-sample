//
//  ZendriveFeedback.h
//  ZendriveSDK
//
//  Created by Yogesh on 1/11/17.
//  Copyright © 2017 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZendriveEvent.h"

/**
 * The category that best indicates the type of trip
 */
typedef NS_ENUM(NSUInteger, ZendriveDriveCategory) {
    /**
     * Indicates that the trip was taken in a car
     */
    ZendriveDriveCategoryCar = 0,

    /**
     * Indicates that the trip was taken in a car and the user was the driver
     */
    ZendriveDriveCategoryCarDriver = 1,

    /**
     * Indicates that the trip was taken in a car and the user was a passenger
     */
    ZendriveDriveCategoryCarPassenger = 2,

    /**
     * Indicates that the trip was taken in a train or a subway
     */
    ZendriveDriveCategoryTrain = 3,

    /**
     * Indicates that the trip was taken in a bus
     */
    ZendriveDriveCategoryBus = 4,

    /**
     * Indicates that the trip was taken on a bicycle
     */
    ZendriveDriveCategoryBicycle = 5,

    /**
     * Indicates that the trip was taken on a motorcycle
     */
    ZendriveDriveCategoryMotorcycle = 6,

    /**
     * Indicates that the trip was taken on foot (either walking or running)
     */
    ZendriveDriveCategoryFoot = 7,

    /**
     * Indicates that the trip was taken using some form of public transit
     * (bus/train/subway/tram etc)
     */
    ZendriveDriveCategoryTransit = 8,

    /**
     * Indicates that there wasn't enough movement and this shouldn't have been
     * detected as a trip
     */
    ZendriveDriveCategoryInvalid = 97,

    /**
     * Indicates that the trip was not taken in a car. This includes everything
     * other than ZendriveDriveCategoryCar
     */
    ZendriveDriveCategoryNotCar = 98,

    /**
     * Fallback when the above options do not cover the use case.
     *
     * This maybe used when the mode of transport is not covered above (eg. snow-mobile) or
     * when enough information is not available to put it in one of the above categories
     */
    ZendriveDriveCategoryOther = 99
};

/**
 * Class for providing feedback back to Zendrive
 */
@interface ZendriveFeedback : NSObject

/**
 * @abstract Help Zendrive improve by providing feedback for a drive detected by the SDK.
 *
 * @param driveId As returned at the end of drive in ZendriveDriveInfo.
 * @param driveCategory The category that best indicates the type of Drive.
 */
+ (void)addDriveCategoryWithDriveId:(nonnull NSString *)driveId
                      driveCategory:(ZendriveDriveCategory)driveCategory;

/**
 * @abstract Help Zendrive improve by providing information about whether an
 * event detected by the SDK occurred or not.
 *
 * @param driveId As returned at the end of drive in ZendriveDriveInfo which
 * this event is part of
 * @param eventTimestamp As returned in [ZendriveEvent startTime]
 * @param eventType As returned in [ZendriveEvent eventType]
 * @param occurrence Whether the event occurred or not
 */
+ (void)addEventOccurrenceWithDriveId:(nonnull NSString *)driveId
                       eventTimestamp:(long long)eventTimestamp
                            eventType:(ZendriveEventType)eventType
                           occurrence:(BOOL)occurrence;
@end
