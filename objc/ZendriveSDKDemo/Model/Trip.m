//
//  Trip.m
//  ZendriveSDKDemo
//
//  Created by Yogesh on 3/7/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "Trip.h"
#import "LocationPoint.h"

#define kStartDateTimestampSecondsKey       @"startDateTimestampSeconds"
#define kEndDateTimestampSecondsKey         @"endDateTimestampSeconds"
#define kAverageSpeedKey                    @"averageSpeed"
#define kDistanceKey                        @"distance"
#define kWaypointsKey                       @"waypoints"
#define kTripStatusKey                      @"tripStatus"

@implementation Trip

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSNumber *startDateTimestampSeconds = [dictionary objectForKey:kStartDateTimestampSecondsKey];
        if (startDateTimestampSeconds) {
            _startDate = [NSDate dateWithTimeIntervalSince1970:(startDateTimestampSeconds.longLongValue)];
        }

        NSNumber *endDateTimestampSeconds = [dictionary objectForKey:kEndDateTimestampSecondsKey];
        if (endDateTimestampSeconds) {
            _endDate = [NSDate dateWithTimeIntervalSince1970:(endDateTimestampSeconds.longLongValue)];
        }

        NSNumber *averageSpeed = [dictionary objectForKey:kAverageSpeedKey];
        if (averageSpeed) {
            _averageSpeed = averageSpeed.doubleValue;
        }

        NSNumber *distance = [dictionary objectForKey:kDistanceKey];
        if (distance) {
            _distance = distance.doubleValue;
        }

        NSMutableArray *waypoints = [[NSMutableArray alloc] init];
        NSArray *waypointDictioariesArray = [dictionary objectForKey:kWaypointsKey];
        for (NSDictionary *waypointDictionary in waypointDictioariesArray) {
            LocationPoint *locationPoint = [[LocationPoint alloc] initWithDictionary:waypointDictionary];
            [waypoints addObject:locationPoint];
        }
        _waypoints = waypoints;

        _tripStatus = [dictionary objectForKey:kTripStatusKey];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.startDate) {
        [dictionary setObject:@(self.startDate.timeIntervalSince1970) forKey:kStartDateTimestampSecondsKey];
    }
    if (self.endDate) {
        [dictionary setObject:@(self.endDate.timeIntervalSince1970) forKey:kEndDateTimestampSecondsKey];
    }

    [dictionary setObject:@(self.averageSpeed) forKey:kAverageSpeedKey];
    [dictionary setObject:@(self.distance) forKey:kDistanceKey];

    NSMutableArray *waypointDictioariesArray = [[NSMutableArray alloc] init];
    for (LocationPoint *locationPoint in self.waypoints) {
        [waypointDictioariesArray addObject:locationPoint.toDictionary];
    }
    [dictionary setObject:waypointDictioariesArray forKey:kWaypointsKey];

    if (self.tripStatus) {
        [dictionary setObject:self.tripStatus forKey:kTripStatusKey];
    }

    return dictionary;
}
@end
