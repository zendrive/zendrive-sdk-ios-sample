//
//  ZendriveInsurance.h
//  ZendriveSDK
//
//  Created by Yogesh on 7/14/17.
//  Copyright © 2017 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @abstract Applications which want to record insurance periods for a driver may use these APIs.
 *
 * @discussion All drives (automatically detected or manually started) when a period is in progress 
 * will be tagged with the period id. This period id will be made available in the reports and API
 * that Zendrive provides.
 *
 * Only one period can be active at a time.
 * Switching periods or calling stopPeriod stops any active drives (automatic or manual).
 * A drive with multiple insurance periods will be split into multiple trips for different
 * insurance periods.
 */
@interface ZendriveInsurance : NSObject

/**
 * @abstract Start insurance period 1 in the SDK.
 *
 * @discussion Trips in this period will be detected automatically.
 *
 * @param error A valid error of ZendriveErrorDomain.kZendriveErrorDomain ('ZendriveError') is
 * returned in case of a failure.
 * Possible error codes returned: kZendriveErrorNotSetup, kZendriveErrorInsurancePeriodSame.
 * Refer to ZendriveError for more details on the errors.
 */
+ (void)startPeriod1:(NSError **)error;

/**
 * @abstract Start insurance period 2 in the SDK.
 *
 * @discussion A manual trip of id trackingId will be started immediately on this call.
 * The entire duration in this period will be recorded as a single trip. 
 * If period 2 is already in progress with the same trackingId, this call will be a no-op.
 *
 * @param trackingId An identifier which allows identifying this drive uniquely.
 * This drive identifier must be unique for the user.
 * @param error A valid error of ZendriveErrorDomain.kZendriveErrorDomain ('ZendriveError') is
 * returned in case of a failure.
 * Possible error codes returned: kZendriveErrorNotSetup, kZendriveErrorInsurancePeriodSame,
 * kZendriveErrorInvalidTrackingId. Refer to ZendriveError for more details on the errors.
 */
+ (void)startDriveWithPeriod2:(NSString *)trackingId error:(NSError **)error;

/**
 * @abstract Start insurance period 3 in the SDK.
 *
 * @discussion A manual trip of id trackingId will be started immediately on this call.
 * The entire duration in this period will be recorded as a single trip.
 * If period 3 is already in progress with the same trackingId, this call will be a no-op.
 *
 * @param trackingId An identifier which allows identifying this drive uniquely.
 * This drive identifier must be unique for the user.
 * @param error A valid error of ZendriveErrorDomain.kZendriveErrorDomain ('ZendriveError') is
 * returned in case of a failure.
 * Possible error codes returned: kZendriveErrorNotSetup, kZendriveErrorInsurancePeriodSame,
 * kZendriveErrorInvalidTrackingId. Refer to ZendriveError for more details on the errors.
 */
+ (void)startDriveWithPeriod3:(NSString *)trackingId error:(NSError **)error;

/**
 * @abstract Stop currently ongoing insurance period if any.
 *
 * @discussion Ongoing trips at the time of this call will be stopped.
 * Auto trip detection is turned off on this call.
 *
 * @param error A valid error of ZendriveErrorDomain.kZendriveErrorDomain ('ZendriveError') is
 * returned in case of a failure.
 * Possible error codes returned: kZendriveErrorNotSetup.
 * Refer to ZendriveError for more details on the errors.
 */
+ (void)stopPeriod:(NSError **)error;
@end
