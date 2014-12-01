//
//  ZendriveSetupError.h
//  Zendrive
//
//  Created by Sumant Hanumante on 29/05/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.
//

#ifndef ZendriveSetupError_h
#define ZendriveSetupError_h

/**
 *  ZendriveSetupError
 *
 *  Discussion:
 *    Error returned as code to NSError from Zendrive setup.
 */
enum {
    /**
     * Invalid parameters sent to setup
     */
    kZendriveSetupErrorInvalidParams = 0,

    /**
     * Keystring being used is deprecated/invalid
     */
    kZendriveSetupErrorInvalidKeyString,

    /**
     * SDK has been disabled from the server
     */
    kZendriveSetupErrorSDKDisabled,

    /**
     * Network not reachable
     */
    kZendriveSetupErrorNetworkUnreachable,

    /**
     * User has disallowed/restricted location services
     */
    kZendriveSetupErrorLocationDisabled,

    /**
     * Internal error during setup
     */
    kZendriveSetupErrorInternalFailure,

    /**
     * Invalid operation mode sent to setup
     */
    kZendriveSetupErrorOperationModeInvalid,

    /**
     * Cannot verify the API key.
     */
    kZendriveSetupErrorCannotVerifyAPIKey,

    /**
     * Zendrive SDK does not support the OS version of the device
     */
    kZendriveSetupErrorUnsupportedOSVersion
};

#endif
