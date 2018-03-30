//
//  ZendriveDebug.h
//  ZendriveSDK
//
//  Created by Vishal Verma on 30/01/18.
//  Copyright © 2018 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZendriveConfiguration;
@protocol ZendriveDebugDelegateProtocol;

/**
 * Status of the debug upload request. As received in the delegate.
 **/
typedef NS_ENUM(int, ZendriveDebugUploadStatus) {
    // Success.
    ZendriveDebugUploadStatusSuccess = 0,

    // Failed due to missing driverId.
    ZendriveDebugUploadStatusFailedMissingDriverId,

    // Failed due to missing application key.
    ZendriveDebugUploadStatusFailedMissingApplicationKey,

    // Failed due to some other reason while uploading.
    ZendriveDebugUploadStatusFailedInternal
};

/**
 * ZendriveDebug Object.
 **/
@interface ZendriveDebug : NSObject

/**
 * @abstract
 * Upload all zendrive related data that will help in debugging.
 *
 * @discussion
 * The method uploads all data to the zendrive servers via a background upload task.
 * This does not require the Zendrive SDK to be setup but needs a valid application key.
 * This is a no-op if upload is already in progress.
 *
 * @param configuration The configuration object which should have valid value of applicaitonKey and
 *                       driverId.
 * @param delegate The delegate which will receive success or failure callbacks.
 *                   No callback will be deliverd if the user force terminates the app while a download
 *                    is going on.
 *
 **/
+ (void)uploadAllZendriveDataWithZendriveConfiguration:(nonnull ZendriveConfiguration *)configuration
                                              delegate:(nullable __weak id<ZendriveDebugDelegateProtocol>)delegate;

/**
 * @abstract
 * Check using a session identifier if the corresponding session was started for data upload.
 *
 * @discussion
 * Typically this method should be used to check the ownership of a session idenfier obtained in
 * application:handleEventsForBackgroundURLSession:completionHandler: method of
 * UIApplicationDelegate
 **/
+ (BOOL)isZendriveSessionIdentifier:(nonnull NSString *)identifier;

/**
 * @abstract
 * Tell the SDK that events for a NSUrlSession are waiting to be processed.
 *
 * @discussion
 * The call to application:handleEventsForBackgroundURLSession:completionHandler: method of UIApplicationDelegate
 * should be forwarded here if it is a Zendrive session identifier. This will ensure the correct
 * handling of the relevant session creation and callbacks to the delegate.
 *
 * @param identifier The identifier in application:handleEventsForBackgroundURLSession:completionHandler:
 * @param completionHandler The completionhandler in application:handleEventsForBackgroundURLSession:completionHandler:
 * @param delegate The delegate which will receive the success and failure messages
 *
 **/
+ (void)handleEventsForBackgroundURLSession:(nonnull NSString *)identifier
                          completionHandler:(nonnull void (^)(void))completionHandler;

+ (void)setDelegate:(nullable id<ZendriveDebugDelegateProtocol>)delegate;
@end

@protocol ZendriveDebugDelegateProtocol <NSObject>

- (void)zendriveDebugUploadFinished:(ZendriveDebugUploadStatus)status;
@end
