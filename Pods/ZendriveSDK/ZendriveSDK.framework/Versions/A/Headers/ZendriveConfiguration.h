//
//  ZendriveConfiguration.h
//  Zendrive
//
//  Created by Sumant Hanumante on 11/11/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Specifies the operation category for Zendrive SDK.
 *  Each category varies in the type and frequency of data collected, accuracy of
 *  drive-related attributes and battery consumption.
 */
typedef NS_ENUM(int, ZendriveOperationMode) {
    /**
     * Default value.
     */
    ZendriveOperationModeNotDetermined = 0,

    /**
     * This operation mode should be used by applications which require Zendrive's
     * driver analytics.
     * In this mode, you get full access to Zendrive REST API and Dashboard
     * including driver scores and analytics.
     * Note that this mode has a slightly higher power consumption than the ones
     * below.
     */
    ZendriveOperationModeDriverAnalytics,

    /**
     * This operation mode should be used by applications which only require
     * drive start/end detection, and do not require driver analytics.
     * In this mode, you would not be able to get driver scores and analytics
     * from Zendrive's REST API. You can still query the APIs for a list of
     * drives and users.
     */
    ZendriveOperationModeDriveTracking
};

@class ZendriveDriverAttributes;

/**
 *  This class contains parameters required by Zendrive during setup.
 */
@interface ZendriveConfiguration : NSObject

/**
 * @abstract Your application key.
 *
 * @discussion Pass in the application key for your app. If you don't
 * have one, please create one at http://developer.zendrive.com/developer-portal/signup
 *
 * This field is REQUIRED and should be a valid string.
 * Check [Zendrive isValidInputParameter:] to validate this field. Nil strings are not
 * allowed.
 * Passing invalid string would cause SDK setup to fail.
 */
@property (nonatomic) NSString *applicationKey;

/**
 * @abstract Unique ID for the current user. This can be any ID used by your app to
 * identify its users. This is the ID which will be used in Zendrive reports.
 * Use [Zendrive isValidInputParameter:] to verify that userId is valid.
 *
 * @discussion This field is REQUIRED and should be a valid string.
 * Check [Zendrive isValidInputParameter:] to validate this field. Nil strings are not
 * allowed.
 * Passing invalid string would cause SDK setup to fail.
 */
@property (nonatomic) NSString *driverId;

/**
 * @abstract Attributes for the current user. These attributes are stored on the server
 * and are provided in Zendrive's APIs. Any existing attributes would be overwritten
 * on the server when a non-nil value for this param is passed. Passing nil is a no-op.
 *
 * @discussion Use this param to provide meta-information about the user like name,
 * email, groupId or any custom attributes you wish to provide.
 * Default value is nil.
 */
@property (nonatomic) ZendriveDriverAttributes *driverAttributes;

/**
 * @abstract You should assign a value to this property that is appropriate for your usage
 * scenario. For example, if you need only drive start/end detection with coarse
 * distance and waypoints, use ZendriveOperationModeDriveTracking.
 *
 * @discussion Refer to ZendriveOperationMode documentation for choosing a mode which
 * suits your application requirements.
 * Once setup, all drives detected by the SDK would be in the specified operationMode. If
 * you wish to change the operation mode at any point, you need to call
 * @method [Zendrive teardown] and setup the SDK again.
 * This field is REQUIRED. If this field is not explicitly set, SDK setup would fail.
 */
@property (nonatomic) ZendriveOperationMode operationMode;

@end
