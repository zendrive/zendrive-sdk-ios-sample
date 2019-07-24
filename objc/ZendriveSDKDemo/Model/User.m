//
//  User.m
//  ZendriveSDKDemo
//
//  Created by Yogesh on 4/15/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "User.h"

static NSString *kDriverIdKey = @"driverId";
static NSString *kFullNameKey = @"fullName";
static NSString *kPhoneNumberKey = @"phoneNumber";
@implementation User

- (instancetype)initWithFullName:(NSString *)fullName
                     phoneNumber:(NSString *)phoneNumber driverId:(NSString *)driverId {
    self = [super init];
    if (self) {
        _fullName = fullName;
        _phoneNumber = phoneNumber;
        _driverId = driverId;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)userDictionary {
    NSString *fullName = [userDictionary objectForKey:kFullNameKey];
    NSString *driverId = [userDictionary objectForKey:kDriverIdKey];
    NSString *phoneNumber = [userDictionary objectForKey:kPhoneNumberKey];
    return [self initWithFullName:fullName phoneNumber:phoneNumber driverId:driverId];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (self.driverId) {
        [dictionary setObject:self.driverId forKey:kDriverIdKey];
    }
    if (self.fullName) {
        [dictionary setObject:self.fullName forKey:kFullNameKey];
    }
    if (self.phoneNumber) {
        [dictionary setObject:self.phoneNumber forKey:kPhoneNumberKey];
    }
    return dictionary;
}

- (NSString *)firstName {
    if (self.fullName) {
        NSArray *nonEmptyNameComponents = [self nonEmptyWordsInString:self.fullName];
        if (nonEmptyNameComponents.count > 0) {
            return nonEmptyNameComponents[0];
        }
    }
    return nil;
}

- (NSString *)lastName {
    if (self.fullName) {
        NSMutableArray *nonEmptyNameComponents = [[self nonEmptyWordsInString:self.fullName] mutableCopy];
        if (nonEmptyNameComponents.count > 1) {
            [nonEmptyNameComponents removeObjectAtIndex:0];
            return [nonEmptyNameComponents componentsJoinedByString:@" "];
        }
    }
    return nil;
}

#pragma mark - Utils
- (NSArray *)nonEmptyWordsInString:(NSString *)str {
    NSArray *stringComponents = [self.fullName componentsSeparatedByString:@" "];

    NSPredicate *nonEmptyStringPredicate = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *nonEmptyComponents = [stringComponents filteredArrayUsingPredicate:nonEmptyStringPredicate];
    return nonEmptyComponents;
}
@end
