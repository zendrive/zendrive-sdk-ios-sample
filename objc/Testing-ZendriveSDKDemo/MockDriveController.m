//
//  MockDriveController.m
//  ZendriveSDKDemo
//
//  Created by Sudeep Kumar on 20/12/18.
//  Copyright © 2018 Zendrive. All rights reserved.
//

#import "MockDriveController.h"
#import <ZendriveSDKTesting/ZendriveMockDrive.h>
#import <ZendriveSDK/Zendrive.h>

#define kSimulationTime 20000   // 20 seconds

@interface MockDriveController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *mockDrivePresets;
@property (nonatomic) NSArray *mockDriveNames;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@end

@implementation MockDriveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSMutableArray *tempMockDrivePresets = [[NSMutableArray alloc] init];
    NSMutableArray *tempMockDriveNames = [[NSMutableArray alloc] init];

    NSDictionary *presetNameToType = [self getPresetNamesAndType];
    for (NSString *name in presetNameToType) {
        ZendrivePresetTripType tripType = (ZendrivePresetTripType)[presetNameToType[name] intValue];
        ZendriveMockDriveBuilder *mockDriveBuilder = [ZendriveMockDriveBuilder presetMockDrive:tripType];
        ZendriveMockDrive *drive = [mockDriveBuilder build];
        [tempMockDriveNames addObject:name];
        [tempMockDrivePresets addObject:drive];
    }

    //add custom drive
    [tempMockDriveNames addObject:@"Small Custom Trip"];
    ZendriveMockDriveBuilder *customMockDriveBuilder = [self getCustomMockDriveBuilder];
    ZendriveMockDrive *drive = [customMockDriveBuilder build];
    [tempMockDrivePresets addObject:drive];

    self.mockDrivePresets = tempMockDrivePresets;
    self.mockDriveNames = tempMockDriveNames;
    [self.tableView reloadData];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------
#pragma mark - UITableViewDatasource
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mockDrivePresets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"mockDriveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }


    ZendriveMockDrive *mockDrive = [self.mockDrivePresets objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.mockDriveNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f miles, simulation time: %d secs", mockDrive.distance/1600.0, kSimulationTime/1000];

    return cell;
}

//------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate
//------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ZendriveMockDrive *drive = [self.mockDrivePresets objectAtIndex:indexPath.row];
    NSError *error;
    [drive simulateDrive:kSimulationTime error:&error];
    if (error) {
        NSLog(@"simulate drive failed with error:%@", error);
    }
}

//------------------------------------------------------------------------------
#pragma mark - Utils
//------------------------------------------------------------------------------

- (NSDictionary *)getPresetNamesAndType {
    return @{
             @"Urban 10 Min Trip": @(Urban10MinTrip),
             @"Highway 60 Min Trip": @(Highway60MinTrip),
             @"Urban 30 Min Trip With Collision": @(Urban30MinWithCollisionTrip),
             @"Non-driving 60 Min Trip ": @(NonDriving60MinTrip),
             @"Invalid Trip": @(InvalidTrip),
             };
}


/**
 * A custom mock drive is created here.
 */
- (ZendriveMockDriveBuilder *)getCustomMockDriveBuilder {
    ZendriveMockDriveBuilder *builder = [ZendriveMockDriveBuilder newAutoDriveBuilderWithStartTimestamp:1547377162258
                                                                                           endTimestamp:1547377172258];
    [builder setAverageSpeed:26.2];
    [builder setDistance:262.002];
    [builder setDriveType:ZendriveDriveTypeDrive];

    ZendriveMockAggressiveAccelerationEventBuilder *eventBuilder = [[ZendriveMockAggressiveAccelerationEventBuilder alloc] initWithTimestamp:1547377132258];
    [eventBuilder setLocation:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377132258 latitude:27.4286474 longitude:-82.5644964]];
    [builder addEventBuilder:eventBuilder];

    [builder setMaxSpeed:3.356];
    [builder setScore:[[ZendriveDriveScore alloc] initWithZendriveScore:85]];
    [builder setUserMode:ZendriveUserModeDriver];
    [builder setWayPoints:[self getCustomWaypoints]];
    [builder setPhonePosition:ZendrivePhonePositionMount];
    [builder setTripStartDelayMillis:2000];
    [builder setTripEndDelayMillis:1000];
    [builder setTripAnalysisDelayMillis:3000];

    return builder;
}

- (NSArray<ZendriveLocationPoint *> *)getCustomWaypoints {
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377162258 latitude:27.0382277 longitude:-82.3982518]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377163258 latitude:27.0366903 longitude:-82.3979069]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377164258 latitude:27.030562 longitude:-82.397899]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377165258 latitude:27.0301696 longitude:-82.3978863]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377166258 latitude:27.0301696 longitude:-82.3978863]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377167258 latitude:27.0299162 longitude:-82.3978964]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377168258 latitude:27.029754 longitude:-82.3974771]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377169258 latitude:27.0297027 longitude:-82.3958005]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377170258 latitude:27.02929 longitude:-82.3934606]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377171258 latitude:27.0292905 longitude:-82.3927091]];
    [arr addObject:[[ZendriveLocationPoint alloc] initWithTimestamp:1547377172258 latitude:27.0293029 longitude:-82.3921103]];

    return arr;
}

@end
