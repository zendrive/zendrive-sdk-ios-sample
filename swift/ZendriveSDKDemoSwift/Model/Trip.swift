//
//  Trip.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 18/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation

final class Trip {
    var startDate: Date?
    var endDate: Date?
    var averageSpeed: Double
    var waypoints: [LocationPoint]
    var distance: Double
    var tripstatus: String?
    var tags: [Tag]

    private let startDateKey = "startDate"
    private let endDateKey = "endDate"
    private let averageSpeedKey = "averageSpeed"
    private let distanceKey = "distance"
    private let waypointsKey = "waypoints"
    private let tripStatusKey = "tripStatus"
    private let tagsKey = "tags"

    init() {
        averageSpeed = 0.0
        waypoints  = []
        tags = []
        distance = 0.0
        tripstatus = ""
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

        if let tagDictionaries = dictionary?[tagsKey] as? [[String: String]] {
            var tags:[Tag] = []
            for tagDict in tagDictionaries {
                tags.append(Tag(dictionary: tagDict))
            }
            self.tags = tags
        }

        if let tripstatus = dictionary?[tripStatusKey] as? String {
            self.tripstatus = tripstatus
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

        var waypointDictionaries: [[AnyHashable: Any]] = []
        for waypoint in self.waypoints {
            waypointDictionaries.append(waypoint.toDictionary())
        }

        var tagDictionaries: [[String: String]] = []
        for tag in self.tags {
            tagDictionaries.append(tag.toDictionary())
        }

        dictionary[waypointsKey] = waypointDictionaries
        dictionary[tagsKey] = tagDictionaries
        dictionary[distanceKey] = self.distance
        dictionary[averageSpeedKey] = self.averageSpeed
        return dictionary
    }
}
