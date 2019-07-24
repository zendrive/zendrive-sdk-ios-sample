//
//  UserConsentViewController.m
//  ZendriveSDKDemo
//
//  Created by Atul Manwar on 13/05/19.
//  Copyright © 2019 Zendrive. All rights reserved.
//

#import "UserConsentViewController.h"

@interface UserConsentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *permissionDialogView;
@property (weak, nonatomic) IBOutlet UILabel *alwaysAllowLabel;
@property (weak, nonatomic) IBOutlet UIButton *grantConsentButton;
@property (weak, nonatomic) IBOutlet UILabel *chooseThisLabel;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;
@end

NSString * const kUserConsentStatusKey = @"com.zendrive.hostApp.userConsent.key";
NSString * const kAllowThirdPartyDataCollectionKey = @"com.zendrive.hostApp.thirdPartyDataCollection.key";

@implementation UserConsentViewController
static NSString *permissionTitle = @"needs access to your Location to work properly.";
static NSString *permissionDescription = @"requires 'Always Allow' location permissions for the map, driving analytics and other features to work properly. Your location data will remain anonymized and will only be shared with 3rd parties in accordance with our Privacy Policy.";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.permissionDialogView.layer setCornerRadius:10.0f];
    [self.alwaysAllowLabel.layer setBorderWidth:2.0f];
    UIColor *highlightColor = [UIColor colorWithRed:(0/255.0f) green:(204/255.0f) blue:(155/255.0f) alpha:1];
    [self.alwaysAllowLabel.layer setBorderColor:[highlightColor CGColor]];
    [self.chooseThisLabel setClipsToBounds:YES];
    [self.chooseThisLabel.layer setCornerRadius:4.0f];

    [self.grantConsentButton.layer setShadowRadius:4.0f];
    [self.grantConsentButton.layer setCornerRadius:4.0f];
    [self.grantConsentButton.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.grantConsentButton.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.grantConsentButton.layer setShadowOpacity:0.4];

    NSString *company = (self.companyName == nil || [self.companyName isEqualToString:@""]) ? @"App" : self.companyName;
    [self.permissionTitleLabel setText:[NSString stringWithFormat:@"%@ %@", company, permissionTitle]];
    NSString *descriptionText = [NSString stringWithFormat:@"%@ %@", company, permissionDescription];
    [self.permissionDescriptionLabel setAttributedText:[self getAttributedStringForText:descriptionText boldText:@"Always Allow"]];
}

- (NSAttributedString *)getAttributedStringForText:(NSString *)text boldText:(NSString *)boldText {
    const CGFloat fontSize = 15;
    NSDictionary *boldAttribute = @{
                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]
                                    };
    NSDictionary *nonBoldAttribute = @{
                                       NSFontAttributeName:[UIFont systemFontOfSize:fontSize]
                                       };
    NSRange range = [text rangeOfString:boldText];
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:nonBoldAttribute];
    [attributedText setAttributes:boldAttribute range:range];
    return attributedText;
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
