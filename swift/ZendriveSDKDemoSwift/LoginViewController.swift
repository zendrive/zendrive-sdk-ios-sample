//
// LoginViewController.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 12/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import UIKit
import ZendriveSDK

var driverId: String?
final class LoginViewController: UIViewController {

    let router: Router = Router()

    @IBOutlet weak var driverIdEmail: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        driverIdEmail.text = ""
        let usr = UserDefaultsManager.sharedInstance().loggedInUser()
        if let usr = usr {
            driverId = usr["loggedInUser"] as? String
            router.present(storyBoardName: "Main", viewControllerId: "TripsViewController",presenter: self, navigation: true)
        }
    }

    @IBAction func loginButton(_ sender: UIButton) {
        driverId = driverIdEmail.text

        if (driverId == nil || !(Zendrive.isValidInputParameter(driverId))) {
            let alert = UIAlertController(title: "Alert", message: "Oops please enter a valid id", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let usr = User(fullName: "firstName lastName", phoneNumber: "1234567890", driverId: driverId!)
        UserDefaultsManager.sharedInstance().setLoggedIn(usr)
        router.present(storyBoardName: "Main", viewControllerId: "TripsViewController",presenter: self, navigation: true)
    }
}

