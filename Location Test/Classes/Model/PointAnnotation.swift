//
//  PointAnnotation.swift
//  Location Test
//
//  Created by isamalazau on 14.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import Foundation
import MapKit

class PointAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    var point: Point?
    
    var markerTintColor: UIColor {
        guard let type = point?.type else { return UIColor(hexString:"#e74c3c") }
        switch type {
        case .hard:
            return UIColor(hexString:"#e74c3c") // red
        case .user:
            return UIColor(hexString:"#f1c40f") // yellow
        }
    }
    
    init(point: Point) {
        self.coordinate = CLLocationCoordinate2DMake(point.lat, point.lng)
        self.title = point.name
        self.subtitle = point.userDescription
        self.point = point
    }
    
    
}
