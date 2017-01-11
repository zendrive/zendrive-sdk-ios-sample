//
//  ZendriveLocationPoint.h
//  Zendrive
//
//  Created by Sumant Hanumante on 22/10/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Represents a geographical coordinate.
 */
@interface ZendriveLocationPoint : NSObject

/**
 * Epoch timestamp of the location point.
 */
@property (nonatomic, readonly) long long timestamp;

/**
 * @abstract Latitude in degrees
 */
@property (nonatomic, readonly) double latitude;

/**
 * @abstract Longitude in degrees
 */
@property (nonatomic, readonly) double longitude;

/**
 *  @abstract Init
 *
 *  @param timestamp Epoch timestamp of the location
 *  @param latitude  Latitude in degrees
 *  @param longitude Longitude in degrees
 *
 *  @return ZendriveLocationPoint object
 */
- (id)initWithTimestamp:(long long)timestamp
               latitude:(double)latitude
             longitude:(double)longitude;

- (NSDictionary *)toDictionary;

@end
