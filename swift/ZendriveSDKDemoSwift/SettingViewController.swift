//
//  SettingViewController.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 26/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import UIKit
import ZendriveSDK

final class SettingViewController: UIViewController {

    @IBOutlet weak var driveDetectionMode: UISegmentedControl!
    @IBOutlet weak var serviceLevel: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let driveDetectionModeValue: ZendriveDriveDetectionMode = UserDefaultsManager.sharedInstance().driveDetectionMode()
        driveDetectionMode.selectedSegmentIndex = Int(driveDetectionModeValue.rawValue)
        let serviceTier = UserDefaultsManager.sharedInstance().serviceTier()
        serviceLevel.selectedSegmentIndex = serviceTier
    }

    @IBAction func driveDetectionMode(_ sender: Any) {
        switch driveDetectionMode.selectedSegmentIndex {
            case 0:
                let driveDetectionMode: ZendriveDriveDetectionMode = .autoON
                UserDefaultsManager.sharedInstance().setDriveDetectionMode(driveDetectionMode)
            case 1:
                let driveDetectionMode: ZendriveDriveDetectionMode = .autoOFF
                UserDefaultsManager.sharedInstance().setDriveDetectionMode(driveDetectionMode)
            default:
                break
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.driveDetectionModeUpdated), object: nil)
    }

    @IBAction func serviceLevel(_ sender: Any) {
        switch serviceLevel.selectedSegmentIndex {
            case 0:
                UserDefaultsManager.sharedInstance().setServiceTier(0)
            case 1:
                UserDefaultsManager.sharedInstance().setServiceTier(1)
            default:
                break
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.serviceTierUpdated), object: nil)
    }

    @IBAction func driveDetectionInfo(_ sender: Any) {
        let alert = UIAlertController(title: "Drive Detection Mode", message: "Choose Auto On if you want drives to be detected automatically.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    @IBAction func serviceLevelInfo(_ sender: Any) {
        let alert = UIAlertController(title: "Service Tier", message: "If you have multiple service tier users in your application like Free/Paidusers, contact us on support@zendrive.comto create special service plans", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func logOutButton(_ sender: Any) {
        UserDefaultsManager.sharedInstance().setLoggedIn(nil)
        let window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        window?.rootViewController = viewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.userLogout), object: nil)
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func uploadDebugDataButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:Constants.Notification.uploadDebugData), object: nil)
    }

    @IBAction func uploadAllZendriveDataButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:Constants.Notification.uploadAllZendriveData), object: nil)
    }
}
