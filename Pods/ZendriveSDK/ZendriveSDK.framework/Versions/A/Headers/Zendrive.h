//  Zendrive.h
//  Zendrive
//
//  Created by Sumant Hanumante on 1/1/14.
//  Copyright (c) 2014 Zendrive Inc. All rights reserved.

#import <Foundation/Foundation.h>

#import "ZendriveConfiguration.h"
#import "ZendriveDriverAttributes.h"
#import "ZendriveDriveStartInfo.h"
#import "ZendriveActiveDriveInfo.h"
#import "ZendriveDriveInfo.h"
#import "ZendriveAccidentInfo.h"
#import "ZendriveLocationPoint.h"
#import "ZendriveErrorDomain.h"
#import "ZendriveSetupError.h"
#import "ZendriveLocationPoint.h"
#import "ZendriveAccidentFeedback.h"
#import "ZendriveEvent.h"
#import "ZendriveDriveScore.h"

/**
 * Identifier used by Zendrive SDK for region monitoring geofences
 */
extern NSString * __nonnull const kZendriveGeofenceIdentifier;

@protocol ZendriveDelegateProtocol;

/**
 * @typedef
 * @abstract Block type used to define blocks called by Zendrive setup on completion
 * @discussion If setup succeeds, success is set to YES and error is nil. If setup fails,
 * success is set to NO and error contains details for why setup failed. Refer to
 * ZendriveSetupError.h for a list of error codes.
 */
typedef void (^ZendriveSetupHandler)(BOOL success, NSError * __nullable error);

/**
 *  Zendrive Object.
 */
@interface Zendrive : NSObject

/**
 * @abstract Initializes the Zendrive library to automatically detect driving and collect
 * data. Client code should call this method before anything else in the Zendrive API.
 *
 * @discussion This method authenticates the configuration with the server asynchronously
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
 * @param handler This block is called when zendrive setup completes.
 *                The application is expected to use the success and error
 *                params passed to this block to handle failures. The handler
 *                would be invoked on the main thread. Can be nil.
 *
 */
+ (void)setupWithConfiguration:(nonnull ZendriveConfiguration *)zendriveConfiguration
                      delegate:(nullable id<ZendriveDelegateProtocol>)delegate
             completionHandler:(nullable ZendriveSetupHandler)handler;

/**
 * @abstract Set delegate to receive callbacks for various events from Zendrive SDK.
 * See ZendriveDelegateProtocol for further details.
 *
 * @discussion Calling this if Zendrvie is not setup is a no-op.
 * @see setupWithConfiguration:delegate:completionHandler: for further details.
 *
 * @param delegate The delegate object to give callbacks on.
 *
 */
+ (void)setDelegate:(nullable id<ZendriveDelegateProtocol>)delegate;

/**
 * @abstract The drive detection mode controls how Zendrive SDK detects drives.
 * See ZendriveDriveDetectionMode for further details.
 *
 * @discussion Use this method to get the current ZendriveDriveDetectionMode.
 */
+ (ZendriveDriveDetectionMode)getDriveDetectionMode;


/**
 * @abstract Change the drive detection mode to control how Zendrive SDK detects drives.
 * See ZendriveDriveDetectionMode for further details. This will override the mode sent
 * with ZendriveConfiguration during setup.
 *
 * @discussion Calling this method stops an ongoing auto-detected drive.
 * Calling this method when the SDK is not setup is a no-op.
 *
 * @param driveDetectionMode The new drive detection mode.
 */
+ (void)setDriveDetectionMode:(ZendriveDriveDetectionMode)driveDetectionMode;

/**
 * @abstract Stops driving data collection. The application can disable the Zendrive SDK
 * by invoking this method. This method is asynchronous.
 *
 * @discussion The teardown method is internally synchronized with
 * setupWithConfiguration:delegate:completionHandler: method, and the enclosing
 * application should avoid synchronizing the two methods independently. If you want a
 * callback on teardown, use teardownWithCompletionHandler: method. This is same as
 * calling teardownWithCompletionHandler: with a nil handler.
 *
 */
+ (void)teardown;

/**
 * @abstract Stops driving data collection. The application can disable the Zendrive SDK
 * by invoking this method. This method is asynchronous.
 *
 * @discussion The teardown method is internally synchronized with
 * setupWithConfiguration:delegate:completionHandler: method, and the enclosing
 * application should avoid synchronizing the two methods independently. Calling this
 * with nil completion handler is same as calling teardown method.
 *
 * @param handler Called when method completes. The handler would be invoked on main
 *        thread. Can be nil.
 */
+ (void)teardownWithCompletionHandler:(void(^ __nullable)(void))handler;

/**
 * @abstract This API allows application to override Zendrive's auto drive detection
 * algorithm.
 *
 * @discussion Invoking this method forces the start of a drive. If this API is
 * used then it is application's responsibility to terminate the drive by
 * invoking stopDrive: method. If an auto-detected drive is in progress, that drive
 * is stopped and a new drive is started.
 *
 * These methods should be used only by applications which have explicit
 * knowledge of start and end of drives and want to attribute drive data to
 * specific trackingIds.
 *
 * Calling it without having initialized the Zendrive framework
 * (setupWithApplicationId) is a no-op.
 *
 * Calling startDrive: with the same trackingId without calling stopDrive: in between
 * is a no-op. Calling startDrive: with a different trackingId: with implicitly call
 * stopDrive: before starting a new drive.
 *
 * @param trackingId Pass a tracking Id to correlate apps internal
 *                   data with the drive data. Cannot be nil or empty string.
 *                   Cannot be longer than 64 characters.
 *                   Sending nil or empty string as tracking id is a no-op.
 *                   Use isValidInputParameter: to verify that groupId is valid.
 *                   Passing invalid string is a no-op.
 *
 * @see stopDrive:
 *
 * @warning You need to call stopDrive: to stop drive data collection.
 */
+ (void)startDrive:(nonnull NSString *)trackingId;

/**
 * @abstract This should be called to indicate the end of a drive started by invoking
 * startDrive:
 *
 * @discussion Calling it without having initialized the Zendrive SDK is a no-op.
 *
 * @see startDrive:
 *
 * @warning This method is deprecated. Use stopDrive: method instead.
 *
 */
+ (void)stopDrive __deprecated;

/**
 * @abstract This should be called to indicate the end of a drive started by invoking
 * startDrive:
 *
 * @discussion This call has no effect on an automatically detected drive that may be
 * in progress.
 * Calling it without having initialized the Zendrive SDK is a no-op.
 *
 * @param trackingId This trackingId should match the trackingId sent to startDrive:
 *                   while starting the current drive. If the trackingIds do not match,
 *                   this function is a no-op. Cannot be nil or empty string.
 *
 * @see startDrive:
 *
 */
+ (void)stopDrive:(nonnull NSString *)trackingId;

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
 * already active with a new sessionId will stop the ongoing session and start a new
 * one.
 *
 * Calling it without having initialized the Zendrive SDK is a no-op.
 *
 * @param sessionId an identifier that identifies this session uniquely. Cannot
 *                  be null or an empty string. Cannot be longer than 64 characters.
 *                  Use isValidInputParameter: to verify that groupId is valid.
 *                  Passing invalid string is a no-op.
 *
 */
+ (void)startSession:(nonnull NSString *)sessionId;

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
 * "?", " ", "&", "/", "\", ";", "#"
 * Non-ascii characters are not allowed.
 *
 * @param input The string to validate.
 * @return YES if the string is nil or valid, NO otherwise.
 *
 */
+ (BOOL)isValidInputParameter:(nullable NSString *)input;

/**
 * @abstract Is the Zendrive SDK already setup?
 *
 * @return YES if Zendrive SDK is already setup. Else NO.
 */
+ (BOOL)isSDKSetup;

/**
 * @abstract This returns the current configuration of Zendrive SDK. Returns nil if SDK is not setup.
 *
 * @discussion This returns a copy of Zendrive configuration. Any modifications to the returned
 * object will have no affect on Zendrive SDK.
 *
 * @return The configuration that was used to setup the SDK.
 */
+ (nullable ZendriveConfiguration *)zendriveConfiguration;

/**
 * @return An identifier which can be used to identify this SDK build.
 */
+ (nonnull NSString *)buildVersion;

/**
 * @return The currently active drive information.
 */
+ (nullable ZendriveActiveDriveInfo *)activeDriveInfo;

/**
 * Provide feedback to Zendrive about the reported collision. The collision is reported by
 * the Zendrive SDK via the [ZendriveDelegateProtocol processAccidentDetected:] callback.
 *
 * @param accidentFeedback The actual information about the accident as per user feedback.
 *
 */
+ (void)addAccidentFeedback:(nonnull ZendriveAccidentFeedback *)accidentFeedback;

/**
 * @abstract Use this parameter to update
 * zendriveConfiguration.accidentDetectionMode before setup.
 * Calling setup with ZendriveAccidentDetectionModeEnabled on an unsupported device
 * will lead to setup failure.
 *
 * Curretly supported devices:
 * - All iphones newer than iPhone 4S
 *
 * @return A boolean indicating whether ZendriveSDK can detect accidents
 * on this devices or not.
 */
+ (BOOL)isAccidentDetectionSupportedByDevice;

/**
 * Returns a NSDictionary with keys as ZendriveEventType and values being BOOL which represent
 * if a particular event will be detected by the SDK on this device.
 */
+ (nonnull NSDictionary *)getEventSupportForDevice;

/**
 * Send a debug report of the current driver to Zendrive.
 */
+ (void)uploadAllDebugDataAndLogs;
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
- (void)processStartOfDrive:(nonnull ZendriveDriveStartInfo *)startInfo;

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
- (void)processEndOfDrive:(nonnull ZendriveDriveInfo *)driveInfo;

/**
 * @abstract This callback is fired on the main thread when an accident is detected by
 * the SDK during a drive. Any ongoing auto-detected/manual drives will be stopped
 * after this point.
 *
 * @param accidentInfo Info about accident.
 *
 */
- (void)processAccidentDetected:(nonnull ZendriveAccidentInfo *)accidentInfo;

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

/**
 * @abstract This method is called when location permission state is determined
 * for the first time or whenever it changes.
 */
- (void)processLocationApproved;
@end
