//
//  User.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 16/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation

final class User {
    private let driverIdKey = "driverId"
    private let fullNameKey = "fullName"
    private let phoneNumberKey = "phoneNumber"

    var fullName:String?
    var phoneNumber:String?
    var driverId:String

    init(fullName: String?, phoneNumber: String?, driverId: String) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.driverId = driverId
    }

    //takes dictionary as parameter to create object, i.e from the userdefault
    convenience init(dictionary userDictionary: [AnyHashable : Any]?) {
        self.init(fullName: "", phoneNumber: "", driverId: "")
        if let userDict = userDictionary {
            self.fullName = userDict[fullNameKey] as? String
            self.driverId = userDict[driverIdKey] as! String
            self.phoneNumber = userDict[phoneNumberKey] as? String
        }
    }

    //convert to dictionary to sotre in userdefault
    func toDictionary() -> [AnyHashable : Any] {
        var dictionary:[AnyHashable : Any] = [:]
        dictionary[driverIdKey] = self.driverId
        if let phoneNumber = self.phoneNumber {
            dictionary[phoneNumberKey] = phoneNumber
        }

        if let fullName = self.fullName {
            dictionary[fullNameKey] = fullName
        }
        return dictionary
    }

    //utility function to seperate firstName and lastName
    func nonEmptyWords(in fullName: String?)-> [String]? {
        let stringComponents = fullName?.components(separatedBy: " ")
        return stringComponents
    }

    //return first name of the user
    var firstName: String? {
        get {
            if let nonEmptyNameComponents = nonEmptyWords(in: self.fullName) {
                if nonEmptyNameComponents.count > 0 {
                    return nonEmptyNameComponents.first
                }
            }
            return nil
        }
    }

    // return last name of the user
    var lastName: String? {
        get {
            if let nonEmptyNameComponents = nonEmptyWords(in: self.fullName) {
                if nonEmptyNameComponents.count > 1 {
                    return nonEmptyNameComponents.last
                }
            }
            return nil
        }
    }
}
