//
//  UserConsentUtility.m
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 13/05/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import "UserConsentUtility.h"

@implementation UserConsentUtility
+ (void)showConsentScreenForCompanyName:(NSString *)companyName
                               delegate:(id<UserConsentViewControllerDelegate>)delegate
               presentingViewController:(UIViewController *)presentingViewController {
    if ([UserConsentUtility isThirdPartyDataCollectionAllowed]) {
        if (![UserConsentUtility isConsentProvidedByTheUser]) {
            UserConsentViewController *consentViewController = [[UserConsentViewController alloc] initWithNibName:@"UserConsentViewController"
                                                                                                           bundle:nil];
            [consentViewController setCompanyName:companyName];
            [consentViewController setDelegate:delegate];
            dispatch_async(dispatch_get_main_queue(), ^{
                [presentingViewController presentViewController:consentViewController
                                                       animated:YES
                                                     completion:nil];
            });
        } else {
            [delegate userDidGrantConsent];
        }
    }
}

+ (BOOL)isConsentProvidedByTheUser {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserConsentStatusKey];
}

+ (BOOL)isThirdPartyDataCollectionAllowed {
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:kAllowThirdPartyDataCollectionKey];
    return ((value == nil) || [[NSUserDefaults standardUserDefaults] boolForKey:kAllowThirdPartyDataCollectionKey]);
}

+ (void)setAllowThirdPartyToCollectData:(BOOL)allow {
    [[NSUserDefaults standardUserDefaults] setBool:allow forKey:kAllowThirdPartyDataCollectionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
