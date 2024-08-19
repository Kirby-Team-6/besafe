//
//  NearbyPlacesModel.swift
//  besafe
//
//  Created by Natasha Hartanti Winata on 18/08/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct NearbyPlace: Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var distance: Double
    var coordinate: CLLocationCoordinate2D
}
