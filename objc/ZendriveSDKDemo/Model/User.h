//
//  User.h
//  ZendriveSDKDemo
//
//  Created by Yogesh on 4/15/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

- (instancetype)initWithFullName:(NSString *)fullName
                     phoneNumber:(NSString *)phoneNumber driverId:(NSString *)driverId;
- (instancetype)initWithDictionary:(NSDictionary *)userDictionary;

- (NSDictionary *)toDictionary;
- (NSString *)firstName;
- (NSString *)lastName;

@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *driverId;
@end
