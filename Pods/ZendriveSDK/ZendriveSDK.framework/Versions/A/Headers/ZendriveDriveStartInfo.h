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
 */
@property (nonatomic) ZendriveLocationPoint *startLocation;

@end
