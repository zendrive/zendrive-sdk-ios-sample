//
//  ZendriveDriverAttributes.h
//  Zendrive
//
//  Created by Sumant Hanumante on 14/10/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Key for first name as returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyFirstName;

/**
 *  Key for last name as returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyLastName;

/**
 *  Key for email as returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyEmail;

/**
 *  Key for groupId returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyGroup;

/**
 *  Key for phoneNumber returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyPhoneNumber;

/**
 *  Key for driverStartDate returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyDriverStartDate;

/**
 * Key for ServiceLevel returned by toJson method.
 */
extern NSString * __nonnull const kDriverAttributesKeyPriority;

/**
 * @typedef
 * @abstract Enumeration for different service levels supported by Zendrive for a driver.
 * By default, drivers will be assigned to the default service level - ZendriveServiceLevelDefault.
 *
 * @discussion This is useful for applications which need special modes in the Zendrive SDK for different
 * drivers - e.g default mode for free users and a advanced mode for paid users.
 *
 * By default, multiple service levels are not enabled for an application.
 * To be able to use different modes for your application, you should contact
 * <a href="mailto:support@zendrive.com">support@zendrive.com</a>
 * with your requirements and get that enabled for your application.
 * Otherwise, if this is not enabled for your application, all drivers get mapped to
 * ZendriveServiceLevelDefault irrespective of the service level specified.
 */
typedef NS_ENUM(int, ZendriveServiceLevel) {
    /**
     * Default service level. This is most common level required by most of the applications
     * that use Zendrive SDK.
     */
    ZendriveServiceLevelDefault,
    /**
     * Special service level 1 that is enabled for a particular application.
     * Contact <a href="mailto:support@zendrive.com">support@zendrive.com</a> with your
     * requirements to get this enabled for your application.
     */
    ZendriveServiceLevel1
};

/**
 * Additional attributes of a Zendrive driver.
 *
 * The application can specify both predefined and custom attributes for a driver.
 * These attributes are associated with a SDK driverId at SDK initialization time.
 * In addition to predefined special attributes, up to 4 custom key value attributes
 * can be associated with a driver using the Zendrive SDK.
 *
 * @warning All attribute keys and values can be atmost 64 characters in length.
 */
@interface ZendriveDriverAttributes : NSObject<NSCopying>

/**
 *  @abstract First name of the user.
 *
 *  @param firstName First name. Max length is 64 characters.
 *
 *  @return YES, if the value was set, NO otherwise.
 */
- (BOOL)setFirstName:(nonnull NSString *)firstName;

/**
 *  @abstract Last name of the user.
 *
 *  @param lastName Last name. Max length is 64 characters.
 *
 *  @return YES, if the value was set, NO otherwise.
 */
- (BOOL)setLastName:(nonnull NSString *)lastName;

/**
 *  @abstract Email of the user.
 *
 *  @param email Email Id. Max length is 64 characters.
 *
 *  @return YES, if the value was set, NO otherwise.
 */
- (BOOL)setEmail:(nonnull NSString *)email;

/**
 * @abstract A unique id that associates the current user to a group. This groupId will
 * be made available as a query parameter to filter users in the reports and API that
 * Zendrive provides.
 *
 * @discussion For example, 'EastCoast' and 'WestCoast' can be groupIds to distinguish
 * users from these regions. Another example would be using city names as groupIds. Check
 * [Zendrive isValidInputParameter:] method to validate group id. Setting an invalid
 * groupId is a no-op and would log an error.
 *
 * @param groupId A string representing the group of a user. Max length is 64 characters.
 *
 * @return YES, if the value was set, NO otherwise.
 *
 */
- (BOOL)setGroup:(nonnull NSString *)groupId;

/**
 * @abstract Phone number of the user.
 *
 * @discussion The phone number should be of the format <country_code><phone_number>.
 * For example 14255526528, with 1 being the country code for US followed by the
 * number. For India, it would be 918877554466, with 91 being the country code.
 *
 * @param phoneNumber Phone number. Max length is 20 characters.
 *
 * @return NO if the phone number string contains any characters other than digits, YES
 *         otherwise.
 */
- (BOOL)setPhoneNumber:(nonnull NSString *)phoneNumber;

/**
 * @abstract The date which the driver signed up/started using your application.
 * The date would be available in YYYY-MM-DD format on Zendrvie dashboard which is
 * also what is would be returned by the toJson: and toDictionary: methods.
 *
 * @param startDate The start date for the user.
 *
 * @return YES, if the value was set, NO otherwise.
 */
- (BOOL)setDriverStartDate:(nonnull NSDate *)startDate;

/**
 * The service level of a driver. This is useful for applications where Zendrive supports
 * different service levels for different drivers. See ServiceLevel
 * for more information about this attribute.
 *
 * @param serviceLevel service tier of the user.
 */
- (BOOL)setServiceLevel:(ZendriveServiceLevel)serviceLevel;

/**
 * @abstract Set the custom attribute of the user.
 *
 * @discussion Up to 4 custom attributes can be set for a user.
 * A new value for an existing key would be overwritten only if the value length
 * is within 64 characters, otherwise the original value would be retained.
 *
 * @param key A key for the custom attribute. The maximum key length is 64 characters.
 * @param value Value of the custom attribute. The maximum value length is 64 characters.
 *
 * @return YES, if the value was set, NO otherwise.
 *
 */
- (BOOL)setCustomAttribute:(nonnull NSString *)value forKey:(nonnull NSString *)key;

/**
 * @abstract Returns the attributes as a json string.
 *
 * @return Driver attributes as a json string. nil if json serialization
 *         fails.
 */
- (nonnull NSString *)asJson;

/**
 * @abstract Returns the driver attributes as a dictionary.
 *
 * @return Driver attributes as a dictionary.
 */
- (nonnull NSDictionary *)asDictionary;

@end
