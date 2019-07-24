//
//  UserConsentViewController.h
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 13/05/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserConsentViewControllerDelegate <NSObject>

- (void)userDidGrantConsent;
- (void)displayPrivacyPolicyScreen;

@end
NS_ASSUME_NONNULL_BEGIN

@interface UserConsentViewController : UIViewController
@property (weak, nonatomic) id<UserConsentViewControllerDelegate> delegate;
@property (nonatomic, nonnull) NSString *companyName;
@end

extern NSString * const kUserConsentStatusKey;
extern NSString * const kAllowThirdPartyDataCollectionKey;
NS_ASSUME_NONNULL_END
