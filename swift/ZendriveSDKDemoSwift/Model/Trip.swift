//
//  Trip.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 18/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation

struct EventRatings {
    let phoneHandlingRating: StarRating
    let hardBrakeRating: StarRating
    let hardTurnRating: StarRating
    let speedingRating: StarRating
    let aggressiveAccelerationRating: StarRating

    private let phoneHandlingRatingKey = "phoneHandlingRating"
    private let hardBrakeRatingKey = "hardBrakeRating"
    private let hardTurnRatingKey = "hardTurnRating"
    private let speedingRatingKey = "speedingRating"
    private let aggressiveAccelerationRatingKey = "aggressiveAccelerationRating"

    enum StarRating: Int {
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case NA = -1

        func getText() -> String {
            switch self {
            case .one:
                return "One"
            case .two:
                return "Two"
            case .three:
                return "Three"
            case .four:
                return "Four"
            case .five:
                return "Five"
            case .NA:
                return "NA"

            }
        }
    }

    init(phoneHandlingRating: Int,
         hardBrakeRating: Int,
         hardTurnRating: Int,
         speedingRating: Int,
         aggressiveAccelerationRating: Int) {
        self.phoneHandlingRating = StarRating(rawValue: phoneHandlingRating) ?? .NA
        self.hardBrakeRating = StarRating(rawValue: hardBrakeRating) ?? .NA
        self.hardTurnRating = StarRating(rawValue: hardTurnRating) ?? .NA
        self.speedingRating = StarRating(rawValue: speedingRating) ?? .NA
        self.aggressiveAccelerationRating = StarRating(rawValue: aggressiveAccelerationRating) ?? .NA
    }

    init(dictionary: [AnyHashable: Any]) {
        phoneHandlingRating = StarRating(rawValue: dictionary[phoneHandlingRatingKey] as? Int ?? -1) ?? .NA
        hardBrakeRating = StarRating(rawValue: dictionary[hardBrakeRatingKey] as? Int ?? -1) ?? .NA
        hardTurnRating = StarRating(rawValue: dictionary[hardTurnRatingKey] as? Int ?? -1) ?? .NA
        speedingRating = StarRating(rawValue: dictionary[speedingRatingKey] as? Int ?? -1) ?? .NA
        aggressiveAccelerationRating = StarRating(rawValue: dictionary[aggressiveAccelerationRatingKey] as? Int ?? -1) ?? .NA
    }

    func toDictionary() -> [AnyHashable : Any] {
        return [
            phoneHandlingRatingKey: phoneHandlingRating.rawValue,
            hardBrakeRatingKey: hardBrakeRating.rawValue,
            hardTurnRatingKey: hardTurnRating.rawValue,
            speedingRatingKey: speedingRating.rawValue,
            aggressiveAccelerationRatingKey: aggressiveAccelerationRating.rawValue,
        ]
    }
}

final class Trip {
    var startDate: Date?
    var endDate: Date?
    var averageSpeed: Double
    var waypoints: [LocationPoint]
    var distance: Double
    var tripstatus: String?
    var eventRatings: EventRatings?

    private let startDateKey = "startDate"
    private let endDateKey = "endDate"
    private let averageSpeedKey = "averageSpeed"
    private let distanceKey = "distance"
    private let waypointsKey = "waypoints"
    private let tripStatusKey = "tripStatus"
    private let eventRatingsKey = "eventRatings"

    init() {
        averageSpeed = 0.0
        waypoints  = [ ]
        distance = 0.0
        tripstatus = ""
        eventRatings = nil
    }

    convenience init(dictionary: [AnyHashable : Any]?) {
        self.init()
        if let startDate =  dictionary?[startDateKey] as? Date {
            self.startDate = startDate
        }

        if let endDate = dictionary?[endDateKey] as? Date {
            self.endDate = endDate
        }

        if let averageSpeed = dictionary?[averageSpeedKey] as? Double {
            self.averageSpeed = averageSpeed
        }

        if let distance = dictionary?[distanceKey] as? Double {
            self.distance = distance
        }

        if let waypointDictionaries = dictionary?[waypointsKey] as? [[AnyHashable: Any]] {
            var waypoints:[LocationPoint] = []
            for waypointDict in waypointDictionaries {
                waypoints.append(LocationPoint(dictionary: waypointDict))
            }
            self.waypoints = waypoints
        }

        if let tripstatus = dictionary?[tripStatusKey] as? String {
            self.tripstatus = tripstatus
        }

        if let eventRatingsDict = dictionary?[eventRatingsKey] as? [AnyHashable: Any] {
            self.eventRatings = EventRatings(dictionary: eventRatingsDict)
        }
    }

    func toDictionary() -> [AnyHashable : Any] {
        var dictionary: [AnyHashable : Any] = [:]
        if let tripstatus = self.tripstatus {
            dictionary[tripStatusKey] = tripstatus
        }

        if let startDate = self.startDate {
            dictionary[startDateKey] = startDate
        }

        if let endDate = self.endDate {
            dictionary[endDateKey] = endDate
        }

        if let eventRatingsDict = eventRatings?.toDictionary() {
            dictionary[eventRatingsKey] = eventRatingsDict
        }

        var waypointDictionaries = [[:]]
        for waypoint in self.waypoints {
            waypointDictionaries.append(waypoint.toDictionary())
        }

        dictionary[waypointsKey] = waypointDictionaries
        dictionary[distanceKey] = self.distance
        dictionary[averageSpeedKey] = self.averageSpeed
        return dictionary
    }
}
