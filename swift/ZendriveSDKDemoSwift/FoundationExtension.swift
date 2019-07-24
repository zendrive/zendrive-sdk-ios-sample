//
//  FoundationExtension.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 06/08/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let fullStyleFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzzz"
        return dateFormatter
    }()

    static let shortStyleFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy, HH:mm"
        return dateFormatter
    }()
}
