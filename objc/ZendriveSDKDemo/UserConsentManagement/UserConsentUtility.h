//
//  UserConsentUtility.h
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 13/05/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserConsentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserConsentUtility : NSObject
+ (void)showConsentScreenForCompanyName:(NSString *)companyName
                               delegate:(id<UserConsentViewControllerDelegate>)delegate
               presentingViewController:(UIViewController *)presentingViewController;
+ (BOOL)isConsentProvidedByTheUser;
+ (BOOL)isThirdPartyDataCollectionAllowed;
+ (void)setAllowThirdPartyToCollectData:(BOOL)allow;
@end

NS_ASSUME_NONNULL_END
