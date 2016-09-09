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
     * SDK Key used in setup is invalid
     */
    kZendriveSetupErrorInvalidKeyString,

    /**
     * SDK has been disabled from the server
     *
     * @warning Deprecated. kZendriveSetupErrorInvalidKeyString is returned
     * if SDK is disabled from server.
     */
    kZendriveSetupErrorSDKDisabled __attribute__((deprecated)),

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
     * @warning Deprecated. operationMode in ZendriveConfiguration is deprecated, so
     * this error will never be seen.
     */
    kZendriveSetupErrorOperationModeInvalid __attribute__((deprecated)),

    /**
     * Cannot verify the API key.
     *
     * @warning Deprecated. This was returned if network timed out. @use kZendriveSetupErrorNetworkUnreachable.
     */
    kZendriveSetupErrorCannotVerifyAPIKey __attribute__((deprecated)),

    /**
     * Zendrive SDK does not support the OS version of the device
     */
    kZendriveSetupErrorUnsupportedOSVersion,

    /**
     * Application tried to setup Zendrive with a request to enable a service
     * (ex:Accident Detection) that the application is not authorized to use.
     *
     * @warning Deprecated. All services of ZendriveSDK are open now, this
     * error is never be returned.
     */
    kZendriveSetupErrorUnauthorizedServiceRequest __attribute__((deprecated)),

    /**
     * Zendrive SDK does not support the device.
     */
    kZendriveSetupErrorDeviceUnsupported
};

#endif
