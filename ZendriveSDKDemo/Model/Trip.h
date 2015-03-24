//
//  Trip.h
//  ZendriveSDKDemo
//
//  Created by Yogesh on 3/7/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) double averageSpeed;
@property (nonatomic, assign) double distance;
@property (nonatomic, strong) NSArray *waypoints;
@end
