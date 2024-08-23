import Foundation
import MapKit
import CoreLocation

class SafePlaceUtils {
    static private let priorityOrder: [String: Int] = [
        "police": 1,
        "fire_station": 2,
        "hospital": 3,
        "hotel": 4,
        "resort_hotel": 4,
        "bank": 5,
        "convenience_store": 6,
        "gas_station": 7,
        "shopping_mall": 8,
        "supermarket": 8,
        "department_store": 8,
        "university": 9,
        "church": 10,
        "hindu_temple": 11,
        "mosque": 12,
        "synagogue": 13
    ]
    
    static func sortSafePlaces(_ places: [PlaceModel], from userLocation: CLLocation) -> [PlaceModel] {
        // Filter places to only include those that are open
        let openPlaces = places.filter { $0.currentOpeningHours?.openNow == true }
        
        var combinedPlaces = openPlaces
        
        // Add custom places (assume custom places are always open)
        
        
        print("Combined Places Count: \(combinedPlaces.count)")
        
        return combinedPlaces.sorted { (place1, place2) -> Bool in
            let distance1 = calculateDistance(from: userLocation, to: place1)
            let distance2 = calculateDistance(from: userLocation, to: place2)
            
//            print("Comparing \(place1.displayName?.text ?? "Unknown") and \(place2.displayName?.text ?? "Unknown")")
//            print("Distance1: \(distance1), Distance2: \(distance2)")
            
            let distanceDifference = abs(distance1 - distance2)
            let distanceTolerance: Double = 10.0
            
            if distanceDifference <= distanceTolerance {
                if place1.primaryType == "custom" && place2.primaryType != "custom" {
//                    print("\(place1.displayName?.text ?? "Unknown") is a custom place and has priority over \(place2.displayName?.text ?? "Unknown")")
                    return true
                } else if place1.primaryType != "custom" && place2.primaryType == "custom" {
//                    print("\(place2.displayName?.text ?? "Unknown") is a custom place and has priority over \(place1.displayName?.text ?? "Unknown")")
                    return false
                }
                
                let priority1 = priorityOrder[place1.primaryType] ?? Int.max
                let priority2 = priorityOrder[place2.primaryType] ?? Int.max
                if priority1 != priority2 {
//                    print("\(place1.displayName?.text ?? "Unknown") has priority \(priority1) vs \(priority2) for \(place2.displayName?.text ?? "Unknown")")
                    return priority1 < priority2
                } else {
//                    print("Both have same priority, comparing by ID")
                    return place1.id < place2.id
                }
            } else {
//                print("Distances are not within tolerance, sorting by distance")
                return distance1 < distance2
            }
        }
    }
    
    static func calculateDistance(from userLocation: CLLocation, to place: PlaceModel) -> Double {
        guard let location = place.location else { return Double.greatestFiniteMagnitude }
        let placeLocation = CLLocation(latitude: location.latitude!, longitude: location.longitude!)
        return userLocation.distance(from: placeLocation)
    }
    
    #if os(iOS)
    static func directionAppleWatch(from: CLLocation, to: CLLocation, completion: @escaping (RouteModel)->Void)  {
        let source = from.coordinate
        let destination = to.coordinate
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                return
            }
            
            let routeModel = RouteModel(
                distance: route.distance,
                placeDirectionName: "Test", time: route.expectedTravelTime,
                steps: route.steps.map{
                    return StepsRoute(instruction: $0.instructions, latitude: $0.polyline.coordinate.latitude, longitude: $0.polyline.coordinate.longitude)
                },
                polyLine: convertPolylineToCoordinates(polyline: route.polyline).map {
                    return RoutePolyline($0.latitude, $0.longitude)
                }
            )
            
            completion(routeModel)
        }
    }
    static func convertPolylineToCoordinates(polyline: MKPolyline) -> [CLLocationCoordinate2D] {
        let pointCount = polyline.pointCount
        var coordinates = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        polyline.getCoordinates(&coordinates, range: NSRange(location: 0, length: pointCount))
        return coordinates
    }
    #endif
    
        
}
