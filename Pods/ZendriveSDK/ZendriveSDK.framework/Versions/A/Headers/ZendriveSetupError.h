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
typedef NS_ENUM(int, ZendriveSetupError) {
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
     *
     * @warning Deprecated. Now ZendriveSDK setup will succeed and
     * [ZendriveDelegateProtocol processLocationDenied] callback will be sent. This
     * error will never be fired from ZendriveSDK.
     */
    kZendriveSetupErrorLocationDisabled __attribute__((deprecated)),

    /**
     * Internal error during setup
     */
    kZendriveSetupErrorInternalFailure,

    /**
     * Invalid operation mode sent to setup
     *
     * @warning operationMode in ZendriveConfiguration is deprecated, so
     * this error will never be seen.
     */
    kZendriveSetupErrorOperationModeInvalid __attribute__((deprecated)),

    /**
     * Cannot verify the API key.
     */
    kZendriveSetupErrorCannotVerifyAPIKey,

    /**
     * Zendrive SDK does not support the OS version of the device
     */
    kZendriveSetupErrorUnsupportedOSVersion,

    /**
     * Application tried to setup Zendrive with a request to enable a service
     * (ex:Accident Detection) that the application is not authorized to use.
     */
    kZendriveSetupErrorUnauthorizedServiceRequest,

    /**
     * Zendrive SDK does not support the device.
     */
    kZendriveSetupErrorDeviceUnsupported
};

#endif
