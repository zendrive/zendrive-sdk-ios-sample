//
//  LocationPoint.h
//  ZendriveSDKDemo
//
//  Created by Yogesh on 3/7/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationPoint : NSObject

- (instancetype)initWithLatitude:(double)latitude
             longitude:(double)longitude;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@end
