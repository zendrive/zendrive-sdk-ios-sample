//
//  TripsViewController.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 22/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import UIKit
import ZendriveSDKSwift

final class TripsViewController: UIViewController, ZendriveDelegate, ZendriveDebugDelegate, UITableViewDelegate, UITableViewDataSource {
    private let zendriveSDKKeyString = "Your SDK Key"
    @IBOutlet weak var mockAccidentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var driveStatusLabel: UILabel!
    @IBOutlet weak var driverIdLabel: UILabel!
    @IBOutlet weak var startDriveButton: UIButton!
    @IBOutlet weak var endDriveButton: UIButton!
    var isZendriveSetup = false
    var tripsArray: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadView()
        self.tripsArray = UserDefaultsManager.sharedInstance().fetchAllTrips() ?? []
        tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.registerForNotifications()
        mockAccidentButton.isEnabled = false
        self.navigationItem.title = "ZendriveSDKDemo"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped(sender:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaultsManager.sharedInstance().loggedInUser() == nil {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    func reloadView() {
        if !isZendriveSetup {
            let user = User(dictionary: UserDefaultsManager.sharedInstance().loggedInUser())
            driverIdLabel.text = user.driverId
            initializeSDK(for: user, successHandler: {
                // Will be called on main queue
                self.isZendriveSetup = true
                self.driveStatusLabel.text = "Initialized successfully"
            }, andFailureHandler: { err in
                self.driveStatusLabel.text = "Failed to initialize zendrive :\((err as NSError?)?.localizedFailureReason ?? "")"
            })
        }
    }

    // Action handling
    @objc func settingsButtonTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func mockAccidentButton(_ sender: Any) {
        ZendriveTest.raiseMockAccident(.high)
    }

    @IBAction func startDriveButton(_ sender: Any) {
        NotificationManager.displayNotification(message: "Trip Started")
        Zendrive.startManualDrive("Your_tracking_id_is_here", completionHandler: {isSuccess, error in
            // Drive has started
            if !isSuccess {
                AppLogger.logError("Error in start drive")
                return
            }
        })
    }

    @IBAction func endDriveButton(_ sender: Any) {
        Zendrive.stopManualDrive({ isSuccess, error in
            if !isSuccess {
                AppLogger.logError("Error in ending manual drive")
                return
            }
        })
        mockAccidentButton.isEnabled = false
    }

    // View handling
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tripsArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "tripCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }

        let trip: Trip? = self.tripsArray[indexPath.row]
        if let startDate = trip?.startDate {
            var textLabelText: String = DateFormatter.shortStyleFormatter.string(from: startDate)
            trip?.tags.forEach({ tag in
                textLabelText =  textLabelText + ("\n" + tag.key + ": " + tag.value)
            })
            cell?.textLabel?.text = textLabelText
            cell?.textLabel?.numberOfLines = 0
        }

        let duration = Int((trip?.endDate?.timeIntervalSince1970 ?? 0.0) - (trip?.startDate?.timeIntervalSince1970 ?? 0.0))
        if let distance = trip?.distance, let tripStatus = trip?.tripstatus {
            cell?.detailTextLabel?.text = String(format: "%.2f Meters, %i seconds, %@", distance, duration, tripStatus)
        }

        return cell!
    }

    func debugUploadFinished(_ status: DebugUploadStatus) {
        AppLogger.logDebug("ZendriveDebugUploadFinished : \(status.rawValue)")
        var result: String

        if status.rawValue == 0 {
            result = "Zendrive Debug Upload Finished"
        } else {
            result = "Zendrive Debug Upload Failed : \(status.rawValue)"
        }

        NotificationManager.displayNotification(message: result)
        let alert = UIAlertController(title: "Note", message: result, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil )
    }

    // notification handling
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedOut(_:)), name: NSNotification.Name(rawValue: Constants.Notification.userLogout), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(driveDetectionModeUpdated(_:)), name: NSNotification.Name(rawValue: Constants.Notification.driveDetectionModeUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serviceTierUpdated(_:)), name: NSNotification.Name(rawValue: Constants.Notification.serviceTierUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadDebugDataAndLogs(_:)), name: NSNotification.Name(rawValue: Constants.Notification.uploadDebugData), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadAllZendriveData(_:)), name: NSNotification.Name(rawValue: Constants.Notification.uploadAllZendriveData), object: nil)
    }

    @objc func userLoggedOut(_ notification: Notification?) {
        Zendrive.teardown(completionHandler: {
            self.isZendriveSetup = false
        })
    }

    @objc func driveDetectionModeUpdated(_ notification: Notification?) {
        let driveDetectionMode = UserDefaultsManager.sharedInstance().driveDetectionMode()
        Zendrive.setDriveDetectionMode(driveDetectionMode, completionHandler: nil)
    }

    @objc func serviceTierUpdated(_ notification: Notification?) {
        Zendrive.teardown(completionHandler: {
            self.isZendriveSetup = false
            self.reloadView()
        })
    }

    @objc func uploadDebugDataAndLogs(_ notification: Notification?) {
        Zendrive.uploadAllDebugDataAndLogs()
    }

    @objc func uploadAllZendriveData(_ notification: Notification?) {
        let user = User(dictionary: UserDefaultsManager.sharedInstance().loggedInUser())
        let config = Configuration()
        config.applicationKey = zendriveSDKKeyString
        config.driverId = user.driverId
        ZendriveDebug.uploadAllZendriveData(with: config, delegate: self)
    }

    // SDK initialization
    func initializeSDK(for user: User, successHandler successBlock: @escaping () -> Void, andFailureHandler failureBlock: @escaping (Error?) -> Void) {
        let configuration = Configuration()
        configuration.applicationKey = zendriveSDKKeyString
        let driveDetectionMode = UserDefaultsManager.sharedInstance().driveDetectionMode()
        configuration.driveDetectionMode = driveDetectionMode
        configuration.driverId = user.driverId
        let driveAttrs = DriverAttributes()
        var phoneNumber = user.phoneNumber

        if let _ = phoneNumber {
            phoneNumber = phoneNumber?.replacingOccurrences(of: "+", with: "")
            if (phoneNumber?.count ?? 0) > 0 {
                _ = driveAttrs.setAlias(phoneNumber ?? "00000000")
            }
        }

        let serviceLevel = UserDefaultsManager.sharedInstance().serviceTier()
        _ = driveAttrs.setServiceLevel(ServiceLevel(rawValue: Int32(serviceLevel))!)
        configuration.driverAttributes = driveAttrs
        Zendrive.setup(with: configuration, delegate: self, completionHandler: {sucess, error in
            if sucess {
                successBlock()
            } else {
                failureBlock(error)
            }
        })
    }

    func isAccidentEnabled()-> Bool {
        return Zendrive.isAccidentDetectionSupportedByDevice
    }

    // Zendrive Delegate callbacks
    func processStart(ofDrive startInfo: DriveStartInfo) {
        AppLogger.logInfo("Drive Started \(startInfo.startTimestamp)")
        self.driveStatusLabel.text = "Driving"

        if self.isAccidentEnabled() {
            self.mockAccidentButton.isEnabled = true
        }

        let dateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(startInfo.startTimestamp/1000 )))
        NotificationManager.displayNotification(message: "Trip Started: \(dateString)")
    }

    func processEnd(ofDrive estimatedDriveInfo: EstimatedDriveInfo) {
        AppLogger.logInfo("Drive Ended \(estimatedDriveInfo.endTimestamp)")
        self.driveStatusLabel.text = "Drive Ended"

        if self.isAccidentEnabled() {
            self.mockAccidentButton.isEnabled = false
        }

        let trip = self.getTrip(from: estimatedDriveInfo)
        trip.tripstatus = "Ended"
        UserDefaultsManager.sharedInstance().save(trip)
        self.tripsArray.insert(trip, at: 0)
        self.tableView.reloadData()
        let startDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(estimatedDriveInfo.startTimestamp/1000)))
        let endDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(estimatedDriveInfo.endTimestamp/1000)))
        NotificationManager.displayNotification(message: "Trip Ended \(startDateString), \(endDateString) Distance \(estimatedDriveInfo.distance)")
    }

    func processAnalysis(ofDrive analyzedDriveInfo: AnalyzedDriveInfo) {
        AppLogger.logInfo("Drive Analyzed")
        self.driveStatusLabel.text = "Drive Analyzed"

        if isAccidentEnabled() {
            self.mockAccidentButton.isEnabled = false
        }

        let trip = getTrip(from: analyzedDriveInfo)
        trip.tripstatus = "Analyzed"
        UserDefaultsManager.sharedInstance().update(trip)
        self.tripsArray = UserDefaultsManager.sharedInstance().fetchAllTrips() ?? []
        self.tableView.reloadData()
        let startDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(analyzedDriveInfo.startTimestamp/1000)))
        let endDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(analyzedDriveInfo.endTimestamp/1000)))
        NotificationManager.displayNotification(message: "Drive Analyzed \(startDateString) \(endDateString) Distance \(analyzedDriveInfo.distance)")
    }

    func processResume(ofDrive resumeInfo: DriveResumeInfo) {
        AppLogger.logInfo("Drive Resumed")
        self.driveStatusLabel.text = "Driving Resumed"
        let startDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(resumeInfo.startTimestamp/1000)))
        let gapStartDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(resumeInfo.driveGapStartTimestampMillis/1000)))
        let gapEndDateString = DateFormatter.shortStyleFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(resumeInfo.driveGapEndTimestampMillis/1000)))
        NotificationManager.displayNotification(message: "Trip resumed : \(startDateString) gapStart \(gapStartDateString) gapEnd \(gapEndDateString)")
    }

    func processLocationDenied() {
        self.driveStatusLabel.text = "Location Denied"
        NotificationManager.displayNotification(message: "Location Denied")
    }

    func processLocationApproved() {
        if (self.driveStatusLabel.text != nil && self.driveStatusLabel.text == "Location Denied"){
            self.driveStatusLabel.text = "Location approved"
        }
    }

    func processAccidentDetected(_ accidentInfo: AccidentInfo) {
        AppLogger.logInfo("Accident Detected \(accidentInfo.timestamp)")
        //var alertString: String = ""
        if accidentInfo.confidence == .high {
          //  alertString = "Please respond if you are ok, we will"
            //"send help if you don't respond for a min"
            NotificationManager.displayNotification(message: "Accident detected with high confidence")
        } else {
            //alertString = "Please respond if you are ok, we will send help "
            //"if you don't respond for 10 mins"
            NotificationManager.displayNotification(message: "Accident detected with low confidence")
        }
    }

    func getTrip(from drive: DriveInfo)-> Trip {
        let trip = Trip()
        trip.startDate = Date(timeIntervalSince1970: (TimeInterval(drive.startTimestamp/1000)))
        trip.endDate = Date(timeIntervalSince1970: (TimeInterval(drive.endTimestamp/1000)))
        trip.distance = drive.distance
        trip.averageSpeed = drive.averageSpeed
        trip.waypoints = drive.waypoints.map { (location) -> LocationPoint in
            return LocationPoint(latitude: location.latitude, longitude: location.longitude)
        }
        trip.tags = drive.tags.map { (tag) -> Tag in
            return Tag(key: tag.key, value: tag.value)
        }
        return trip
    }
}

