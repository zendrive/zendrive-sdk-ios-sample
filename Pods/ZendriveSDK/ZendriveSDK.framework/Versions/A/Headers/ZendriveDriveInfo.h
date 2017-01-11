//
//  ZendriveDriveInfo.h
//  Zendrive
//
//  Created by Sumant Hanumante on 25/06/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @abstract The type of the drive return from [ZendriveDriveInfo tripType].
 * @discussion This decides what other ZendriveDriveInfo parameters will be populated.
 * A drive callback can be sent as a false alarm or when we detect that the user was not
 * actually driving but moved using other means of transport.
 */
typedef NS_ENUM(int, ZendriveTripType) {
    /**
     * Sometimes, the SDK detects that a trip is invalid after it has been started.
     * In these cases, the values for [ZendriveDriveInfo waypoints], [ZendriveDriveInfo events],
     * [ZendriveDriveInfo score], [ZendriveDriveInfo maxSpeed] and [ZendriveDriveInfo averageSpeed]
     * will have invalid values.
     */
    ZendriveTripTypeInvalid = 0,

    /**
     * This was not a driving trip. For e.g bike and train rides will fall under this trip type.
     * The ZendriveDriveInfo will have [ZendriveDriveInfo waypoints], [ZendriveDriveInfo maxSpeed]
     * and [ZendriveDriveInfo averageSpeed] but [ZendriveDriveInfo events] and
     * [ZendriveDriveInfo score] will have invalid values.
     */
    ZendriveTripTypeNonDriving = 1,

    /**
     * The trip was taken as a driver of a vehicle.
     * The ZendriveDriveInfo will have [ZendriveDriveInfo waypoints], [ZendriveDriveInfo maxSpeed],
     * [ZendriveDriveInfo averageSpeed], [ZendriveDriveInfo events] and [ZendriveDriveInfo score].*/
    ZendriveTripTypeDrive = 2
};


@class ZendriveDriveScore;
/**
 * ZendriveDriveInfo
 *
 * Wrapper for meta-information related to a drive.
 */
@interface ZendriveDriveInfo : NSObject

/**
 * @abstract The unique Id for this drive
 */
@property (nonatomic, readonly, nonnull) NSString *driveId;

/**
 * @abstract The type of the drive. This decides what other info parameters will be populated.
 * @discussion A drive callback will be sent even for falsely detected drives or for non
 * automobile trips (Eg. biking, public transport).
 */
@property (nonatomic, assign) ZendriveTripType tripType;

/**
 * @abstract The start timestamp of trip in milliseconds since epoch.
 */
@property (nonatomic, assign) long long startTimestamp;

/**
 * @abstract The end timestamp of trip in milliseconds since epoch
 */
@property (nonatomic, assign) long long endTimestamp;

/**
 * @abstract The average speed of trip in metres/second
 */
@property (nonatomic, assign) double averageSpeed;

/**
 * @abstract The maximum speed of trip in metres/second
 * @discussion If we do not receive any accurate location data during the drive, this
 * property would be set to -1
 */
@property (nonatomic, assign) double maxSpeed;

/**
 * @abstract The distance of the trip in metres
 */
@property (nonatomic, assign) double distance;

/**
 * @abstract A list of ZendriveLocationPoint objects corresponding to this trip in
 * increasing order of timestamp. The first point corresponds to trip start location
 * and last to trip end location.
 *
 * @discussion This is a sampled approximation of the drive which gives an indication of
 * the path taken by the driver. It is not the full detailed location data of the drive.
 * If no waypoints are recorded during the drive, this is an empty array.
 */
@property (nonatomic, strong, nonnull) NSArray *waypoints;

/**
 * @abstract Tracking id is specified by the enclosing application when it
 * wants to start a drive manually by calling [Zendrive startDrive:]
 *
 * @discussion This may be the case for example in a taxi cab application that would
 * know when to start a drive based on when a meter gets flagged. trackingId will be
 * nil in case of auto detected drives.
 */
@property (nonatomic, strong, nullable) NSString *trackingId;

/**
 * @abstract Session id is specified by the enclosing application when it wants to
 * record a session using [Zendrive startSession:]
 *
 * @discussion sessionId will be nil if there is no session associated with that drive.
 */
@property (nonatomic, strong, nullable) NSString *sessionId;

/**
 * @abstract A list of ZendriveEvent objects for this trip in increasing order of timestamp.
 * @discussion In case of no events in the trip an empty list is returned.
 */
@property (nonatomic, strong, nonnull) NSArray *events;

/**
 * @abstract The driving behaviour score for this trip.
 */
@property (nonatomic, strong, nonnull) ZendriveDriveScore *score;

@end
