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
        guard let type = point?.type else { return MarkerColor.red }
        switch type {
        case .predefined:
            return MarkerColor.red
        case .user:
            return MarkerColor.yellow
        }
    }
    
    init(point: Point) {
        self.coordinate = CLLocationCoordinate2DMake(point.lat, point.lng)
        self.title = point.name
        self.subtitle = point.userDescription
        self.point = point
    }
}
