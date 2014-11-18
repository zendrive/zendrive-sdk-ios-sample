//
//  ZendriveDriverAttributes.h
//  Zendrive
//
//  Created by Sumant Hanumante on 14/10/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Key for first name as returned by @method toJson method.
 */
extern NSString * const kDriverAttributesKeyFirstName;

/**
 *  Key for last name as returned by @method toJson method.
 */
extern NSString * const kDriverAttributesLastName;

/**
 *  Key for email as returned by @method toJson method.
 */
extern NSString * const kDriverAttributesKeyEmail;

/**
 *  Key for groupId returned by @method toJson method.
 */
extern NSString * const kDriverAttributesKeyGroup;

/**
 * Additional attributes of a Zendrive driver.
 *
 * The application can specify both predefined and custom attributes for a driver.
 * These attributes are associated with a SDK userId at SDK initialization time.
 * In addition to predefined special attributes, up to 4 custom key value attributes
 * can be associated with a user of the Zendrive SDK.
 *
 * All attribute keys and values can be atmost 64 characters in length.
 */
@interface ZendriveDriverAttributes : NSObject

/**
 *  First name of the user.
 *
 *  @param firstName First name. Max length is 64 characters.
 */
- (void)setFirstName:(NSString *)firstName;

/**
 *  Last name of the user.
 *
 *  @param lastName Last name. Max length is 64 characters.
 */
- (void)setLastName:(NSString *)lastName;

/**
 *  Email of the user.
 *
 *  @param email Email Id. Max length is 64 characters.
 */
- (void)setEmail:(NSString *)email;

/**
 * A unique id that associates the current user to a group. This groupId will be made
 * available as a query parameter to filter users in the reports and API that Zendrive
 * provides.
 * For example, 'EastCoast' and 'WestCoast' can be groupIds to distinguish users from
 * these regions. Another example would be using city names as groupIds. Check
 * @see [Zendrive isValidInputParameter:] method to validate group id. Setting an invalid
 * groupId is a no-op and would log an error.
 *
 * @param groupId A string representing the group of a user. Max length is 64 characters.
 *
 */
- (void)setGroup:(NSString *)groupId;

/**
 * Set the custom attribute of the user.
 * Up to 4 custom attributes can be set for a user.
 * A new value for an existing key would be overwritten only if the value length
 * is within 64 characters, otherwise the original value would be retained.
 *
 * @param key A key for the custom attribute. The maximum key length is 64 characters.
 * @param value Value of the custom attribute. The maximum value length is 64 characters.
 *
 */
- (void)setCustomAttribute:(NSString *)value forKey:(NSString *)key;

/**
 *  Returns the attributes as a json string.
 *
 *  @return Driver attributes as a json string. nil if json serialization
 *          fails.
 */
- (NSString *)asJson;

/**
 *  @return Attributes as a dictionary
 */
- (NSDictionary *)asDictionary;

@end
