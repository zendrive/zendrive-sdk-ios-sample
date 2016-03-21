//
//  ZendriveAccidentFeedback.h
//  ZendriveSDK
//
//  Created by Vishal Verma on 24/02/16.
//  Copyright © 2016 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * @typedef
 * @abstract Indicates the direction of impact on the vehicle in which the driver is travelling.
 */
typedef enum ImpactDirection {
    IMPACT_FRONT,
    IMPACT_REAR,
    IMPACT_SIDE
} ImpactDirection;

/**
 * @typedef
 * @abstract Indicate the losses suffered in an accident
 */
typedef enum AccidentLoss {
    /**
     * Minor damage to the driver's vehicle like a fender-bender etc.
     */
    MINOR_DAMAGE,
    /**
     * Major damage to the driver's vehicle requiring body repair.
     */
    MAJOR_DAMAGE,
    /**
     * Driver's vehicle was declared a total loss.
     */
    TOTAL_LOSS
} AccidentLoss;

@interface ZendriveAccidentFeedback : NSObject
- (id)initWithAccidentId:(NSString *)accidentId isAccident:(BOOL)isAccident;
- (void)setAccidentLoss:(AccidentLoss)accidentLoss;
- (void)setImpactDirection:(ImpactDirection)impactDirection;
- (void)setAirbagsDeployed:(BOOL)airbagsDeployed;
- (void)setTowingNeeded:(BOOL)towingNeeded;
- (void)setPersonalInjury:(BOOL)personalInjury;
@end
