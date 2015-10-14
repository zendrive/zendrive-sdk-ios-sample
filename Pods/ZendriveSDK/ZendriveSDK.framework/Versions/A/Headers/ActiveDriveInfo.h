//
//  ActiveDriveInfo.h
//  ZendriveSDK
//
//  Created by Yogesh on 9/10/15.
//  Copyright (c) 2015 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Information about the active drive if any.
 */
@interface ActiveDriveInfo : NSObject

/**
 * @abstract The start timestamp of trip in milliseconds since epoch.
 */
@property (nonatomic) long long startTimestamp;

/**
 * @abstract The average speed of trip in metres/second
 */
@property (nonatomic) double currentSpeed;

/**
 * @abstract The distance of the trip in metres
 */
@property (nonatomic) double distance;

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
