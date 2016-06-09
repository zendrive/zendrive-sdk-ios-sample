//
//  DriveScore.h
//  ZendriveSDK
//
//  Created by Vishal Verma on 19/05/16.
//  Copyright © 2016 Zendrive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Driving Behaviour scores for a drive.
 *
 * The scores are expressed as a number between 0 to 100 and will be -1 if not available.
 *
 * High scores indicate safe driving and low scores reflect hazardous or risky driving patterns.
 * Preventive or corrective actions should be prescribed in extreme cases.
 *
 * More information is available
 * <a href="http://docs.zendrive.com/en/latest/api/scores.html" target="_blank">here</a>
 */
@interface ZendriveDriveScore : NSObject

/**
 * The Zendrive score for this drive. The zendrive score measures the focus, control and
 * cautiousness of a driver. It reflects the accident risk associated with this drive.
 * The scores is expressed as a number between 0 to 100 and will be -1 if not available.
 */
@property (nonatomic, assign) int zendriveScore;

@end
