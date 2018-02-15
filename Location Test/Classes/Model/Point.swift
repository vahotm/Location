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
    case hard = 0
    case user = 1
}

class Point: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var userDescription: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    @objc dynamic var typeRaw: Int8 = PointType.hard.rawValue

    var type: PointType {
        get {
            return PointType(rawValue: typeRaw)!
        }
        set {
            typeRaw = newValue.rawValue
        }
    }
}
