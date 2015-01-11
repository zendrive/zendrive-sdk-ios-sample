//
//  ViewController.m
//  ZendriveSDKDemo
//
//  Created by Sumant Hanumante on 13/10/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import "ViewController.h"
#import <ZendriveSDK/Zendrive.h>

static NSString * kZendriveKeyString = @"<your-application-key>";
static NSString * kDriverId = @"<your-driver-id>";

@interface ViewController () <ZendriveDelegateProtocol>

@property IBOutlet UILabel* driveStatusLabel;
@property IBOutlet UILabel* driveStatsLabel;
@property IBOutlet UIButton* startDriveButton;
@property IBOutlet UIButton* endDriveButton;
@property (nonatomic) BOOL isZendriveSetup;
@property (weak, nonatomic) IBOutlet UILabel *sdkFailedLabel;

@end

@implementation ViewController

- init {
    self = [super initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _isZendriveSetup = NO;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.isZendriveSetup) {
        [self initializeSDKWithSuccessHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isZendriveSetup = YES;
                self.endDriveButton.enabled = YES;
                self.startDriveButton.enabled = YES;
                self.sdkFailedLabel.hidden = YES;
                NSLog(@"Initialized successfully");
            });
        } andFailureHandler:^(NSError *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sdkFailedLabel.hidden = NO;
            });
        }];
    }
}

#pragma mark UIButtonActions

- (IBAction)startDriveTapped:(id)sender {
    [Zendrive startDrive:@"your-tracking-id-here"];
}

- (IBAction)endDriveTapped:(id)sender {
    [Zendrive stopDrive];
}

#pragma mark - Zendrive setup helper

- (void)initializeSDKWithSuccessHandler:(void (^)(void))successBlock
                      andFailureHandler:(void (^)(NSError *))failureBlock {

    __block NSError *error;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZendriveConfiguration *configuration = [[ZendriveConfiguration alloc] init];
        configuration.applicationKey = kZendriveKeyString;
        configuration.driverId = kDriverId;
        configuration.operationMode = ZendriveOperationModeDriverAnalytics;

        BOOL success = [Zendrive setupWithConfiguration:configuration
                                               delegate:self error:&error];
        if(success) {
            successBlock();
        } else {
            failureBlock(error);
        }
    });
}

#pragma mark - Zendrive Delegate collbacks

- (void)processStartOfDrive:(ZendriveDriveStartInfo *)startInfo {
    NSLog(@"Drive started!!");
    self.driveStatusLabel.text = @"Driving";
    self.driveStatsLabel.text = @"";
}

- (void)processEndOfDrive:(ZendriveDriveInfo *)drive {
    NSLog(@"Drive finished!!");
    self.driveStatusLabel.text = @"Drive Ended";
    if (drive.isValid) {
        self.driveStatsLabel.text = [NSString stringWithFormat:@"Last trip distance : %.1f metres", drive.distance];
    } else {
        self.driveStatsLabel.text = @"Invalid trip";
    }
}

@end
