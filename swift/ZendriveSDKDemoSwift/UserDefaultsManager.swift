//
//  UserDefaultsManager.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 19/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation
import ZendriveSDK

private var _sharedInstance: UserDefaultsManager? = nil

final class UserDefaultsManager {
    private let loggedInUserKey = "loggedInUser"
    private let driveDetectionModeKey = "driveDetectionMode"
    private let serviceTierKey = "serviceTier"
    private let tripsUserDefaultsKey = "tripsArray"

    class func sharedInstance() -> UserDefaultsManager {
        if _sharedInstance == nil {
            let lockQueue = DispatchQueue(label: "self")
            lockQueue.sync {
                if _sharedInstance == nil {
                    _sharedInstance = UserDefaultsManager()
                }
            }
        }
        return _sharedInstance!
    }

    func loggedInUser() -> [AnyHashable: Any]? {
        let userDictionary = UserDefaults.standard.object(forKey: loggedInUserKey) as? [AnyHashable : Any]
        return userDictionary
    }

    func setLoggedIn(_ user: User?) {
        UserDefaults.standard.set(user?.toDictionary(), forKey: loggedInUserKey)
    }

    func driveDetectionMode() -> ZendriveDriveDetectionMode {
        let driveDetectionModeNsNum: Int = UserDefaults.standard.integer(forKey: driveDetectionModeKey)
        return ZendriveDriveDetectionMode(rawValue: Int32(driveDetectionModeNsNum))!
    }

    func setDriveDetectionMode(_ driveDetectionMode: ZendriveDriveDetectionMode) {
        UserDefaults.standard.set(driveDetectionMode.rawValue, forKey: driveDetectionModeKey)
        UserDefaults.standard.synchronize()
    }

    func serviceTier() -> Int {

        if let serviceTierNsNum = UserDefaults.standard.object(forKey: serviceTierKey) as? Int {
            return serviceTierNsNum
        }

        return 0
    }

    func setServiceTier(_ serviceTier: Int) {
        UserDefaults.standard.set(serviceTier, forKey: serviceTierKey)
        UserDefaults.standard.synchronize()
    }

    //------------------------------------------------------------------------------
    // MARK: - Trip load/save
    //------------------------------------------------------------------------------
    func save(_ trip: Trip) {
        let userDefaults = UserDefaults.standard
        var newTripDictArray: [[AnyHashable: Any]] = []

        if let tripDictArray = userDefaults.object(forKey: tripsUserDefaultsKey) as? [[AnyHashable: Any]] {
            let array = [trip.toDictionary()] + tripDictArray
            newTripDictArray = array
        } else {
            newTripDictArray = [trip.toDictionary()]
        }
        userDefaults.set(newTripDictArray, forKey: tripsUserDefaultsKey)
        userDefaults.synchronize()
    }

    func update(_ trip: Trip?) {
        let userDefaults = UserDefaults.standard
        let tripDictionary = trip?.toDictionary()
        var tripDictArray = userDefaults.object(forKey: tripsUserDefaultsKey) as? [[AnyHashable: Any]]
        if tripDictArray != nil {
            var index = -1
            for i in 0..<(tripDictArray?.count ?? 0) {
                let thisTripDict = tripDictArray?[i]
                let thisTrip = Trip(dictionary: thisTripDict)
                if thisTrip.startDate == trip?.startDate {
                    index = i
                    break
                }
            }

            if index >= 0 && index < (tripDictArray?.count ?? 0) {
                if let tripDictionary = tripDictionary {
                    tripDictArray?[index] = tripDictionary
                }
            }
        }

        userDefaults.set(tripDictArray, forKey: tripsUserDefaultsKey)
        userDefaults.synchronize()
    }

    func fetchAllTrips() -> [Trip]? {
        var tripsArray: [Trip] = []
        let userDefaults = UserDefaults.standard
        let tripDictArray = userDefaults.object(forKey: tripsUserDefaultsKey) as? [[AnyHashable: Any]]

        if let _ = tripDictArray {
            for i in 0..<(tripDictArray?.count ?? 0) {
                tripsArray.append(Trip(dictionary: tripDictArray![i]))
            }
        }

        return tripsArray
    }

}
