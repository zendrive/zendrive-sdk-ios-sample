//
//  ZendriveDriveStartInfo.h
//  Zendrive
//
//  Created by Sumant Hanumante on 26/10/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZendriveLocationPoint;
/**
 *  Information about start of a drive.
 */
@interface ZendriveDriveStartInfo : NSObject

/**
 * @abstract The start timestamp of trip in milliseconds since epoch
 */
@property (nonatomic) long long startTimestamp;

/**
 * @abstract The start location of the drive.
 *
 * @discussion If the drive is automatically detected by Zendrive SDK, then this location
 * is approximate and close to the start location but not exactly the start location.
 *
 * @warning This is deprecated. Use firstObject of waypoints instead.
 */
@property (nonatomic) ZendriveLocationPoint *startLocation __deprecated;

/**
 * @abstract The distance of the trip in metres
 */
@property (nonatomic) double distance;

/**
 * @abstract A list of ZendriveLocationPoint objects corresponding to this trip in
 * increasing order of timestamp. The first point corresponds to trip start location.
 *
 * @discussion This array contains a series of ZendriveLocationPoint which
 * approximate the path taken by the driver. This is not the detailed location
 * data but rather a sample representing route geometry.
 *
 * @note The array might be empty if no accurate gps location is determined till 
 * [ZendriveDelegateProtocol processStartOfDrive:] call.
 */
@property (nonatomic) NSArray *waypoints;

/**
 * @abstract Tracking id is specified by the enclosing application when it
 * wants to start a drive manually by calling [Zendrive startDrive:]
 *
 * @discussion This may be the case for example in a taxi cab application that would
 * know when to start a drive based on when a meter gets flagged. trackingId will be
 * nil in case of auto detected drives.
 */
@property (nonatomic) NSString *trackingId;

/**
 * @abstract Session id is specified by the enclosing application when it wants to
 * record a session using [Zendrive startSession:]
 *
 * @discussion sessionId will be nil if there is no session associated with that drive.
 */
@property (nonatomic) NSString *sessionId;
@end
