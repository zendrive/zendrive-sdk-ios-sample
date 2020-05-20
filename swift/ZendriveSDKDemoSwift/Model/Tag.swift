//
//  Tag.swift
//  ZendriveSDKDemoSwift
//
//  Created by Abhishek Aggarwal on 21/05/20.
//  Copyright © 2020 zendrive. All rights reserved.
//

import UIKit

class Tag {
    private let kKey = "key"
    private let kValue = "value"

    var key: String
    var value: String

    init(key: String,
         value: String) {
        self.key = key
        self.value = value
    }

    init(dictionary: [String: String]) {
        self.key = dictionary[kKey] ?? ""
        self.value = dictionary[kValue] ?? ""
    }

    func toDictionary() -> [String: String] {
        return [kKey: key,
                kValue:value]
    }
}
