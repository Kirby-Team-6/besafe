//
//  MainViewModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import Foundation
import MapKit

class MainViewModel: ObservableObject {
    @Published var route: MKRoute?
    
    func navigateToSafePlace(latitude: Double, longitude: Double) {
        let source = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let destination = CLLocationCoordinate2D(latitude: 37.775511594494446,longitude:  -122.41872632127603)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                return
            }
        
            self.route = route
        }
    }
}
