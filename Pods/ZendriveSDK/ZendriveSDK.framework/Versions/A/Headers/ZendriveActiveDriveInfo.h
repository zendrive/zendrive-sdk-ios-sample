//
//  ZendriveActiveDriveInfo.h
//  ZendriveSDK
//
//  Created by Yogesh on 9/10/15.
//  Copyright (c) 2015 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Information about the active drive if any.
 */
@interface ZendriveActiveDriveInfo : NSObject

/**
 * @abstract The unique Id for this drive
 */
@property (nonatomic, readonly, nonnull) NSString *driveId;

/**
 * @abstract The start timestamp of trip in milliseconds since epoch.
 */
@property (nonatomic, assign) long long startTimestamp;

/**
 * @abstract The current speed of vehicle in metres/second.
 */
@property (nonatomic, assign) double currentSpeed;

/**
 * @abstract The distance covered so far in this trip in meters.
 */
@property (nonatomic, assign) double distance;

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
@end
