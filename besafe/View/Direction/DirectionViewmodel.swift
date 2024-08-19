//
//  DirectionViewmodel.swift
//  besafe
//
//  Created by Rifat Khadafy on 15/08/24.
//

import Foundation
import MapKit

class DirectionViewmodel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var directions: [String] = []
    @Published var route: MKRoute?
    
    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Example: San Francisco
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    func updateRegion(with region: MKCoordinateRegion) {
        self.region = region
    }
    
    func getDirections( from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                return
            }
            
            self.logRoute(route)
            self.route = route
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            self.region = MKCoordinateRegion(
                center: source,
                span: MKCoordinateSpan(latitudeDelta: abs(source.latitude - destination.latitude) * 1.5, longitudeDelta: abs(source.longitude - destination.longitude) * 1.5)
            )
        }
    }
    
    func logRoute(_ route: MKRoute) {
            print("Route name: \(route.name)")
            print("Distance: \(route.distance) meters")
            print("Expected travel time: \(route.expectedTravelTime) seconds")
            print("Advisory notices: \(route.advisoryNotices.joined(separator: ", "))")
            print("Steps:")
            for step in route.steps {
                print("\t- \(step.instructions) (\(step.distance) meters) \(step.polyline.coordinate)")
                
            }
        }
}
