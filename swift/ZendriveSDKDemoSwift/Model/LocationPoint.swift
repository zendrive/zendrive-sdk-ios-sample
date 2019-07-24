//
//  LocationPoint.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 23/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation

final class LocationPoint {
    private let latitudeKey = "latitude"
    private let longitudeKey = "longitude"
    private(set) var latitude = 0.0
    private(set) var longitude = 0.0
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(dictionary: [AnyHashable : Any]?) {
        if let longitude = dictionary?[longitudeKey] as? Double, let latitude = dictionary?[latitudeKey] as? Double {
            self.longitude = longitude
            self.latitude = latitude
        } else {
            AppLogger.logInfo("No waypoints")
        }
    }

    func toDictionary() -> [AnyHashable : Any] {
        return [latitudeKey: self.latitude, longitudeKey: self.longitude]
    }
}
