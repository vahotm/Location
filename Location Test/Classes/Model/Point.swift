//
//  Point.swift
//  Location Test
//
//  Created by isamalazau on 13.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import Foundation
import RealmSwift


enum PointType: Int8 {
    case predefined = 0
    case user = 1
}

class Point: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var userDescription: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    @objc dynamic var typeRaw: Int8 = PointType.predefined.rawValue

    var type: PointType {
        get {
            return PointType(rawValue: typeRaw)!
        }
        set {
            typeRaw = newValue.rawValue
        }
    }

    convenience init(name: String, userDescription: String = "", latitude: Double, longitude: Double, type: PointType = .predefined) {
        self.init()
        self.name = name
        self.userDescription = userDescription
        self.lat = latitude
        self.lng = longitude
        self.type = type
    }
}
