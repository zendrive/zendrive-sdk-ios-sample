//
//  ZendriveLocationPoint.h
//  Zendrive
//
//  Created by Sumant Hanumante on 22/10/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Represents a geographical coordinate along with accuracy and timestamp information.
 */
@interface ZendriveLocationPoint : NSObject

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
 *  @param latitude  Latitude in degrees
 *  @param longitude Longitude in degrees
 *
 *  @return ZendriveLocationPoint object
 */
- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude;

@end
