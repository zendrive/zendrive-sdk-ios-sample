//
//  ZendriveAccidentFeedback.h
//  ZendriveSDK
//
//  Created by Vishal Verma on 24/02/16.
//  Copyright © 2016 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Indicates the direction of impact on the vehicle in which the driver is travelling.
 */
typedef NS_ENUM(int, ZendriveImpactDirection) {
    /**
     * Vehicle's front part got the first impact
     */
    ZendriveImpactDirectionImpactFront,
    /**
     * Vehicle's rear part got the first impact
     */
    ZendriveImpactDirectionImpactFrontRear,
    /**
     * Vehicle's side part got the first impact
     */
    ZendriveImpactDirectionImpactSide
};

/**
 * Indicate the losses suffered in an accident
 */
typedef NS_ENUM(int, ZendriveAccidentLoss) {
    /**
     * Minor damage to the driver's vehicle like a fender-bender etc.
     */
    ZendriveAccidentLossMinorDamage,
    /**
     * Major damage to the driver's vehicle requiring body repair.
     */
    ZendriveAccidentLossMajorDamage,
    /**
     * Driver's vehicle was declared a total loss.
     */
    ZendriveAccidentLossTotalLoss
};

/**
 * The data associated with an accident based on user feedback.
 * See [Zendrive addAccidentFeedback:] for the usage.
 */
@interface ZendriveAccidentFeedback : NSObject

@property (nonatomic, readonly, nonnull) NSString *accidentId;
@property (nonatomic, readonly) BOOL isAccident;
@property (nonatomic, readonly) ZendriveAccidentLoss accidentLoss;
@property (nonatomic, readonly) ZendriveImpactDirection impactDirection;
@property (nonatomic, readonly) BOOL personalInjury;
@property (nonatomic, readonly) BOOL towingNeeded;
@property (nonatomic, readonly) BOOL airbagsDeployed;

/**
 *  Initialize ZendriveAccidentFeedback using most basic accident information.
 *
 *  @param accidentId accidentId of ZendriveAccidentInfo object returned from 
 *  [ZendriveDelegateProtocol processAccidentDetected:]
 *  @param isAccident Let Zendrive know whether this was a real accident 
 *  or a false positive. This will help Zendrive in improving the algorithm.
 *
 *  @return New ZendriveAccidentFeedback object
 */
- (nullable id)initWithAccidentId:(nonnull NSString *)accidentId isAccident:(BOOL)isAccident;

/**
 *  Set loss incurred in the accident.
 *
 *  @param accidentLoss ZendriveAccidentLoss as seen by user
 */
- (void)setZendriveAccidentLoss:(ZendriveAccidentLoss)accidentLoss;

/**
 *  Set impact direction for the accident.
 *
 *  @param impactDirection ZendriveImpactDirection as seen by user
 */
- (void)setZendriveImpactDirection:(ZendriveImpactDirection)impactDirection;

/**
 *  Let Zendrive know about the airbags state after the impact.
 *
 *  @param airbagsDeployed Yes if airbags were deployed in the collision.
 */
- (void)setAirbagsDeployed:(BOOL)airbagsDeployed;

/**
 *  Let Zendrive know if towing was needed for the impact vehicle.
 *
 *  @param towingNeeded Yes if towing was needed.
 */
- (void)setTowingNeeded:(BOOL)towingNeeded;

/**
 *  Let Zendrive know if there was personal injury to any of the passengers.
 *
 *  @param personalInjury Yes if there was personal injury
 */
- (void)setPersonalInjury:(BOOL)personalInjury;
@end
