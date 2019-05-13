//
//  UserConsentViewController.m
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 13/05/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import "UserConsentViewController.h"

@interface UserConsentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *importantIcon;
@property (weak, nonatomic) IBOutlet UILabel *importantLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *permissionDialogView;
@property (weak, nonatomic) IBOutlet UILabel *alwaysAllowLabel;
@property (weak, nonatomic) IBOutlet UIButton *grantConsentButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;
@end

NSString * const kUserConsentStatusKey = @"com.zendrive.hostApp.userConsent.key";
NSString * const kAllowThirdPartyDataCollectionKey = @"com.zendrive.hostApp.thirdPartyDataCollection.key";

@implementation UserConsentViewController
static NSString *permissionTitle = @"needs access to your Location and Motion Activity to work properly";
static NSString *permissionDescription = @"requires 'Always Allow' location permissions for the map, place alerts and other features to work properly. Your location data will remain anonymized and will only be shared with 3rd parties in accordance with our Privacy Policy.";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.permissionDialogView.layer setCornerRadius:10.0f];
    [self.alwaysAllowLabel.layer setBorderWidth:1.0f];
    UIColor *highlightColor = [UIColor blueColor];
    [self.alwaysAllowLabel.layer setBorderColor:[highlightColor CGColor]];
    [self.grantConsentButton.layer setCornerRadius:(self.grantConsentButton.bounds.size.height/2)];
    NSString *company = (self.companyName == nil || [self.companyName isEqualToString:@""]) ? @"App" : self.companyName;
    [self.permissionTitleLabel setText:[NSString stringWithFormat:@"%@ %@", company, permissionTitle]];
    [self.permissionDescriptionLabel setText:[NSString stringWithFormat:@"%@ %@", company, permissionDescription]];
}

- (IBAction)consentGranted:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserConsentStatusKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.delegate userDidGrantConsent];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)viewPrivacyPolicy:(UIButton *)sender {
    [self.delegate displayPrivacyPolicyScreen];
}
@end
