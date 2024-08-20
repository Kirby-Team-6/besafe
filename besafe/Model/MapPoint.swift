//
//  MapPoint.swift
//  besafe
//
//  Created by Paulus Michael on 14/08/24.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData

@Model 
class MapPoint {
    var name: String
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
