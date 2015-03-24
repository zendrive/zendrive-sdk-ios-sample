//
//  LocationPoint.m
//  ZendriveSDKDemo
//
//  Created by Yogesh on 3/7/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "LocationPoint.h"

#define kLatitudeKey    @"latitude"
#define kLongitudeKey   @"longitude"
@implementation LocationPoint

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude
{
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSNumber *latitude = [dictionary objectForKey:kLatitudeKey];
        _latitude = latitude.doubleValue;

        NSNumber *longitude = [dictionary objectForKey:kLongitudeKey];
        _longitude = longitude.doubleValue;
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{kLatitudeKey:@(self.latitude), kLongitudeKey:@(self.longitude)};
}
@end
