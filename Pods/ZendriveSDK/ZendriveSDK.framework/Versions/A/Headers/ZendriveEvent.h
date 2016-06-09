//
//  ZendriveEvent.h
//  ZendriveSDK
//
//  Created by Vishal Verma on 13/04/16.
//  Copyright © 2016 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZendriveLocationPoint;

/**
 * This is returned in [ZendriveEvent eventSeverity], it represents the
 * severity of event if application for that event type.
 */
typedef NS_ENUM(NSInteger, ZendriveEventSeverity) {
    /**
     * Severity not applicable for this event type.
     */
    ZendriveEventSeverityNone = 0,
    /**
     * This is a low severity event.
     */
    ZendriveEventSeverityLow,
    /**
     * This is a high severity event.
     */
    ZendriveEventSeverityHigh
};

/**
 * The event type as specified in [ZendriveEvent eventType]
 */
typedef NS_ENUM(NSInteger, ZendriveEventType) {
    /**
     * This denotes the aggressive behavior of braking too hard.
     */
    ZendriveEventHardBrake = 0,

    /**
     * This denotes the aggressive behavior of accelerating too fast.
     */
    ZendriveEventAggressiveAcceleration,

    /**
     * This denotes the distracting behavior of using the phone while driving.
     */
    ZendriveEventPhoneUse,

    /**
     * This denotes the aggressive behavior of speeding more than allowed.
     * You will also receive [ZendriveEvent speedingData] in this case.
     */
    ZendriveEventOverSpeeding,

    /**
     * This denotes a collision as detection by ZendriveSDK.
     * You will also receive [ZendriveDelegateProtocol processAccidentDetected:]
     * in realtime for this event.
     */
    ZendriveEventAccident
};

/**
 * A valid object of this class is returned in [ZendriveEvent speedingData]
 * whenever [ZendriveEvent eventType] is equal to ZendriveEventOverSpeeding.
 */
@interface ZendriveSpeedingData : NSObject
/**
 * The speed limit in metres per second.
 */
@property (nonatomic, assign) double speedLimitMPS;
/**
 * The average speed of the user during this speeding event duration in metres per second.
 */
@property (nonatomic, assign) double userSpeedMPS;
/**
 * Maximum speed of the user during this speeding event duration in metres per second.
 */
@property (nonatomic, assign) double maxUserSpeedMPS;

@end

/**
 * Represents a driving behavior event like phone use, aggressive acceleration etc.
 * It is part of ZendriveDriveInfo object of [ZendriveDelegateProtocol processEndOfDrive:] callback.
 */
@interface ZendriveEvent : NSObject
/**
 * Start location of the event.
 */
@property (nonatomic, strong, nonnull) ZendriveLocationPoint *startLocation;
/**
 * Stop location of the event.
 */
@property (nonatomic, strong, nonnull) ZendriveLocationPoint *stopLocation;
/**
 * Epoch timestamp of the start of the event.
 */
@property (nonatomic, assign) long long startTime;
/**
 * Epoch timestamp of the end of the event;
 */
@property (nonatomic, assign) long long endTime;
/**
 * The type of the event.
 */
@property (nonatomic, assign) ZendriveEventType eventType;
/**
 * The severity of the event.
 */
@property (nonatomic, assign) ZendriveEventSeverity eventSeverity;
/**
 * Additional data in the eventType is ZendriveEventOverSpeeding, will be nil otherwise.
 */
@property (nonatomic, strong, nullable) ZendriveSpeedingData *speedingData;
@end


