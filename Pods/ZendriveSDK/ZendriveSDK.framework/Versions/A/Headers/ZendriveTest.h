//
//  ZendriveTest.h
//  Zendrive
//
//  Created by Yogesh on 5/20/15.
//  Copyright (c) 2015 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZendriveAccidentInfo.h"

/**
 * This class contains methods that mock Zendrive's functionality for testing purposes.
 *
 */
@interface ZendriveTest : NSObject

#ifdef DEBUG
/**
 *  Use this method to test Zendrive Accident detection integration. Works only in
 *  DEBUG mode, disabled in RELEASE mode.
 *  On invoking this method, you will get a processAccidentDetected: callback on your
 *  delegate after 5 seconds. You can look at console logs for debugging in case you
 *  do not receive the callback. If issue persists, please contact us at
 *  developers@zendrive.com.
 *
 *  @param confidence Any value from ZendriveAccidentConfidence enum.
 *
 *  @warning While invoking this method on a simulator, make sure your are simulating
 *  location (In title bar, select Debug->Location->Apple).
 */
+ (void)raiseMockAccident:(ZendriveAccidentConfidence)confidence;
#endif

@end
