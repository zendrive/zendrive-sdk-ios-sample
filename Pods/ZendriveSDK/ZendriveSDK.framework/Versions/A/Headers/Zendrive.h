//  Zendrive.h
//  Zendrive
//
//  Created by Sumant Hanumante on 1/1/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.

#import <Foundation/Foundation.h>

#import "ZendriveDriveInfo.h"
#import "ZendriveDriveStartInfo.h"
#import "ZendriveDriverAttributes.h"
#import "ZendriveConfiguration.h"
#import "ZendriveSetupError.h"

@protocol ZendriveDelegateProtocol;

/**
 *  Zendrive Object.
 */
@interface Zendrive : NSObject

/**
 * @abstract Initializes the Zendrive library to automatically detect driving and collect
 * data. Client code should call this method before anything else in the Zendrive API.
 *
 * @discussion The enclosing applications are advised to call this method in a background
 * task since this method authenticates the configuration with the server synchronously
 * before returning status.
 *
 * Calling this method multiple times with the same values for
 * sdkApplicationKey and driverId pair is a no-op.
 * Changing either will be the same as calling teardown followed by calling setup with
 * the new parameters.
 * Please note that even if other configuration parameters like driverAttributes or
 * operationMode are changed, but driverId and sdkApplicationKey remain same,
 * calling this method would still be a no-op.
 * If you want to change these configuration parameters, invoke teardown
 * explicitly and call this method again with the new configuration.
 *
 * This method requires network connection for every time the setup is called with a
 * different value for
 * sdkApplicationKey, driverId pair to validate the sdkApplicationKey from the server.
 * Setup fails and returns NO if network is not available in such cases.
 *
 * This method returns NO whenever setup fails and sets up the error with the
 * error code, cause and description.
 *
 * When data collection needs to be stopped call the teardown method.
 * This might be done for example when the application's user has
 * logged out (and possibly a different user might login later).
 *
 * @param zendriveConfiguration The configuration object used to setup the SDK. This
 *                              object contains your credentials along with
 *                              additional setup parameters that you can use to provide
 *                              meta-information about the user or to tune the sdk
 *                              functionality.
 * @param delegate The delegate object on which Zendrive SDK will issue callbacks for
 *                 handling various events. Can be nil if you do not want to
 *                 register for callbacks.
 *                 The delegate can also be set at a later point using setDelegate:
 *                 method.
 * @param error A reference to a NSError pointer that will contain error detilas
 *              if this function call returns NO. Cannot be nil.
 * @return YES if setup was successful and NO if an error is encountered. The error
 *         details can be found in the error object.
 *
 */
+ (BOOL)setupWithConfiguration:(ZendriveConfiguration *)zendriveConfiguration
                      delegate:(id<ZendriveDelegateProtocol>)delegate
                         error:(NSError **)error;

/**
 * @abstract Set delegate to receive callbacks for various events from Zendrive SDK.
 * See ZendriveDelegateProtocol for further details.
 *
 * @discussion Calling this if Zendrvie is not setup is a no-op.
 * @see setupWithConfiguration:delegate:error: for further details.
 *
 * @param delegate The delegate object to give callbacks on.
 *
 */
+ (void)setDelegate:(id<ZendriveDelegateProtocol>)delegate;

/**
 * @abstract Stops driving data collection. The application can disable the Zendrive SDK
 * by invoking this method.
 */
+ (void)teardown;

/**
 * @abstract This API allows application to override Zendrive's auto drive detection
 * algorithm.
 *
 * @discussion Invoking this method forces the start of a drive. If this API is
 * used then it is application's responsibility to terminate the drive by
 * invoking stopDrive method.
 *
 * These methods should be used only by applications which have explicit
 * knowledge of start and end of drives and want to attribute drive data to
 * specific trackingIds.
 *
 * Calling it without having initialized the Zendrive framework
 * (setupWithApplicationId) is a no-op.
 *
 * Calling startDrive: multiple times without calling stopDrive in between
 * is a no-op.
 *
 * @param trackingId Pass a tracking Id to correlate apps internal
 *                   data with the drive data. Cannot be nil or empty string.
 *                   Cannot be longer than 64 characters.
 *                   Sending nil or empty string as tracking id is a no-op.
 *                   Use isValidInputParameter: to verify that groupId is valid.
 *                   Passing invalid string is a no-op.
 *
 * @see stopDrive
 *
 * @warning You need to call stopDrive to stop drive data collection.
 */
+ (void)startDrive:(NSString *)trackingId;

/**
 * @abstract This should be called to indicate the end of a drive started by invoking
 * startDrive:
 *
 * @see startDrive:
 *
 * Calling it without having initialized the Zendrive SDK is a no-op.
 *
 */
+ (void)stopDrive;

/**
 * Start a session in the SDK.
 *
 * @abstract Applications which want to record several user's drives as a session may use
 * this call.
 *
 * @discussion All drives, either automatically detected or started using startDrive:,
 * will be tagged with the sessionId if a session is already in progress. If a drive
 * is already on when this call is made, that drive will not belong to this
 * session.
 *
 * This session id will be made available as a query parameter in the
 * reports and API that Zendrive provides.
 *
 * The application must call stopSession when it wants to end the session.
 *
 * Only one session may be active at a time. Calling startSession when a session is
 * already active will be a no-op.
 *
 * Calling it without having initialized the Zendrive SDK is a no-op.
 *
 * @param sessionId an identifier that identifies this session uniquely. Cannot
 *                  be null or an empty string. Cannot be longer than 64 characters.
 *                  Use isValidInputParameter: to verify that groupId is valid.
 *                  Passing invalid string is a no-op.
 *
 */
+ (void)startSession:(NSString *)sessionId;

/**
 * @abstract Stop currently ongoing session. No-op if no session is ongoing. Trips that
 * start after this call do not belong to the session. Ongoing trips at the time of this
 * call will continue to belong to the session that was just stopped.
 *
 * @see startSession:
 *
 */
+ (void)stopSession;

/**
 * @abstract Use this method to check whether the parameter string passed
 * to the SDK is valid.
 *
 * @discussion All strings passed as input params to Zendrive SDK cannot contain
 * the following characters-
 * "+", "?", " ", "&", "/", "\", ";", "#"
 * Non-ascii characters are not allowed.
 *
 * @param input The string to validate.
 * @return YES if the string is nil or valid, NO otherwise
 *
 */
+ (BOOL)isValidInputParameter:(NSString *)input;

@end


/**
 *  Delegate for Zendrive.
 */
@protocol ZendriveDelegateProtocol <NSObject>

@optional
/**
 *
 * @abstract Called on delegate in the main thread when Zendrive SDK detects a potential
 * start of a drive.
 *
 * @param startInfo Info about drive start. Refer to ZendriveDriveStartInfo for
 *                  further details.
 *
 */
- (void)processStartOfDrive:(ZendriveDriveStartInfo *)startInfo;

/**
 * @abstract Called on the delegate in the main thread when Zendrive SDK detects a drive
 * to have been completed.
 *
 * @discussion It is possible that Zendrive SDK might decide at a later time that an
 * ongoing trip was a falsely detected trip. In such scenario processEndOfDrive: will be
 * invoked on delegate with ZendriveDriveInfo.isValid set to NO.
 *
 * @param driveInfo Info about entire drive. Refer to ZendriveDriveInfo for
 *                  further details.
 *
 */
- (void)processEndOfDrive:(ZendriveDriveInfo *)driveInfo;

/**
 * @abstract This callback is fired on main thread when location services are denied for
 * the SDK. After this callback, drive detection is paused until location
 * services are re-enabled for the SDK.
 *
 * @discussion The expected behaviour is that the enclosing application shows an
 * appropriate popup prompting the user to allow location services for the app.
 *
 * The callback is triggered once every time location services are denied by the user
 * and can be triggered in background or in foreground, depending on whether the SDK
 * has enough CPU time to execute.
 *
 */
- (void)processLocationDenied;

@end
