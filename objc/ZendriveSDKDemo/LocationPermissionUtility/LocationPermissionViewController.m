//
//  LocationPermissionViewController.m
//  ZendriveOnduty
//
//  Created by Yogesh on 11/19/16.
//  Copyright © 2016 Zendrive. All rights reserved.
//

#import "LocationPermissionViewController.h"

@interface LocationPermissionViewController ()

@property (nonatomic, weak) IBOutlet UIButton *openSettingsButton;
@end

@implementation LocationPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _openSettingsButton.tintColor = [UIColor whiteColor];
    [_openSettingsButton setTitleColor:[UIColor blackColor]
                              forState:UIControlStateHighlighted|UIControlStateSelected];
    [_openSettingsButton setSelected:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openSettingsButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                     [self dismissViewControllerAnimated:YES
                                                              completion:nil];
                                 }];
    }
}

- (IBAction)retainPresentAuthorization:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


@end
