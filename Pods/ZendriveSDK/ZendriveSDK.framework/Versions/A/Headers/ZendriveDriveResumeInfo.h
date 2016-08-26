//
//  ZendriveDriveResumeInfo.h
//  ZendriveSDK
//
//  Created by Yogesh on 8/5/16.
//  Copyright © 2016 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Information about a drive that was resumed in the Zendrive SDK.
 *
 * This is called after the drive recording resumes after a gap. The gap may occur due to
 * an application restart by the OS, application kill and restart by a user, an application crash
 * etc.
 */
@interface ZendriveDriveResumeInfo : NSObject

/**
 * @abstract The unique Id for this drive
 */
@property (nonatomic, readonly, nonnull) NSString *driveId;

/**
 * @abstract The start timestamp of trip in milliseconds since epoch.
 */
@property (nonatomic, assign) long long startTimestamp;

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
 * @abstract The start timestamp of the gap in drive recording in millisecs.
 * @discussion The drive was resumed after this gap.
 */
@property (nonatomic) long long driveGapStartTimestampMillis;

/**
 * @abstract The end timestamp of the gap in drive recording in millisecs.
 * @discussion The drive was resumed after this gap.
 */
@property (nonatomic) long long driveGapEndTimestampMillis;

@end
