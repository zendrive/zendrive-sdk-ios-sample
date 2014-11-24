//
//  ZendriveDriveInfo.h
//  Zendrive
//
//  Created by Sumant Hanumante on 25/06/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * ZendriveDriveInfo
 *
 * Wrapper for meta-information related to a drive.
 */
@interface ZendriveDriveInfo : NSObject

/**
 * @abstract Sometimes, the SDK detects that a drive is invalid after it has been started.
 * In these cases, the isValid property will be set to NO and values for all other
 * properties in this class have default values.
 */
@property (nonatomic) BOOL isValid;

/**
 * @abstract The start timestamp of trip in milliseconds since epoch.
 */
@property (nonatomic) long long startTimestamp;

/**
 * @abstract The end timestamp of trip in milliseconds since epoch
 */
@property (nonatomic) long long endTimestamp;

/**
 * @abstract The average speed of trip in metres/second
 */
@property (nonatomic) double averageSpeed;

/**
 * @abstract The distance of the trip in metres
 */
@property (nonatomic) double distance;

/**
 * @abstract A list of ZendriveLocationPoint objects corresponding to this trip in
 * increasing order of timestamp. The first point corresponds to trip start location
 * and last to trip end location.
 *
 * @discussion This is a sampled approximation of the drive which gives an indication of
 * the path taken by the driver. It is not the full detailed location data of the drive.
 * If no waypoints are recorded during the drive, this is an empty array.
 */
@property (nonatomic) NSArray *waypoints;

@end
