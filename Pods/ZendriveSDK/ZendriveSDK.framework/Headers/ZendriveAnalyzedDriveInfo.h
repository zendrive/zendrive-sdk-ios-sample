//
//  ZendriveAnalyzedDriveInfo.h
//  ZendriveSDK
//
//  Created by Yogesh on 3/16/17.
//  Copyright © 2017 Zendrive Inc. All rights reserved.
//

#import "ZendriveDriveInfo.h"

/**
 * This contains the fully analyzed results for a drive, this is returned from
 * processAnalysisOfDrive: callback for all the trips with the value of
 * ZendriveDriveInfo.driveType not set to ZendriveDriveTypeInvalid.
 *
 * The data of this type will always be of equal or better quality than
 * ZendriveEstimatedDriveInfo returned from processEndOfDrive:
 *
 * Typically processAnalysisOfDrive: will be fired within
 * a few seconds after processEndOfDrive: callback but in some rare cases
 * this delay can be really large depending on phone network conditions.
 *
 * The callback for this processAnalysisOfDrive: will be fired in trip
 * occurrence sequence, i.e. from oldest trip to the latest trip.
 */
@interface ZendriveAnalyzedDriveInfo : ZendriveDriveInfo

@end
