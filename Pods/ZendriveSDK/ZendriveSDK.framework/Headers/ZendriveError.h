//
//  ZendriveSetupError.h
//  Zendrive
//
//  Created by Sumant Hanumante on 29/05/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#ifndef ZendriveError_h
#define ZendriveError_h

/**
 *  ZendriveError
 *
 *  Discussion:
 *    Error returned as code to NSError from Zendrive public APIs in case of
 *    failures.
 */
typedef NS_ENUM(int, ZendriveError) {
    /**
     * SDK Key used in setup is invalid
     */
    kZendriveErrorInvalidSDKKeyString = 0,

    /**
     * Network not reachable, Zendrive.setup sometimes needs network call
     * for authentication and to update SDK configuration to work. This error
     * is returned whenever network is not available in these scenarios.
     */
    kZendriveErrorNetworkUnreachable = 1,

    /**
     * Zendrive SDK does not support the OS version of the device.
     */
    kZendriveErrorUnsupportedOSVersion = 2,

    /**
     * Zendrive SDK does not support the device type.
     */
    kZendriveErrorDeviceUnsupported = 3,

    /**
     * Invalid parameter was passed to the API.
     */
    kZendriveErrorInvalidParams = 101,

    /**
     * Internal error.
     */
    kZendriveErrorInternalFailure = 102,

    /**
     * ZendriveSDK is not setup. This error is also returned in case SDK setup
     * has started but completion handler for setup is not called yet.
     */
    kZendriveErrorNotSetup = 103,

    /**
     * Insurance Period hasn't changed from the previously active period, action ignored.
     * This error may be returned from startPeriod1, startDriveWithPeriod2,
     * startDriveWithPeriod3 APIs of ZendriveInsurance.
     */
    kZendriveErrorInsurancePeriodSame = 104,

    /**
     * Invalid trackingId passed for new drive. This error may be returned from
     * startDriveWithPeriod2, startDriveWithPeriod3 APIs of ZendriveInsurance.
     */
    kZendriveErrorInvalidTrackingId = 105
};

#endif
