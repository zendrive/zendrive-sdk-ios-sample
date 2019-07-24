//
//  NotificationManager.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 19/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

final class NotificationManager {

    class func displayNotification (message: String?) {

        if #available(iOS 10.0, *){
            let localNotification: UNMutableNotificationContent = UNMutableNotificationContent()
            localNotification.title = "Notification"
            localNotification.body = message ?? ""
            localNotification.sound = .default
            let notifactionRequest: UNNotificationRequest = UNNotificationRequest(identifier: "id", content: localNotification, trigger: nil)
            UNUserNotificationCenter.current().add(notifactionRequest){(error: Error?) in
            }
        } else {
            // for earlier version
            let localNotification = UILocalNotification()
            localNotification.alertBody = message
            localNotification.alertAction = "Open"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = 1
            UIApplication.shared.presentLocalNotificationNow(localNotification)
        }
    }
}
