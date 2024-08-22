import Foundation
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
    
    static func sortSafePlaces(_ places: [PlaceModel], customPlaces: [MapPoint], from userLocation: CLLocation) -> [PlaceModel] {
        // Filter places to only include those that are open
        let openPlaces = places.filter { $0.currentOpeningHours?.openNow == true }
        
        var combinedPlaces = openPlaces
        
        // Add custom places (assume custom places are always open)
        for customPlace in customPlaces {
            let placeModel = PlaceModel(
                id: UUID().uuidString,
                location: Location(latitude: customPlace.coordinate.latitude, longitude: customPlace.coordinate.longitude),
                currentOpeningHours: CurrentOpeningHours(openNow: true),
                primaryType: "custom",
                displayName: DisplayName(text: customPlace.name, languageCode: nil),
                shortFormattedAddress: nil
            )
            combinedPlaces.append(placeModel)
        }
        
        print("Combined Places Count: \(combinedPlaces.count)")
        
        return combinedPlaces.sorted { (place1, place2) -> Bool in
            let distance1 = calculateDistance(from: userLocation, to: place1)
            let distance2 = calculateDistance(from: userLocation, to: place2)
            
            print("Comparing \(place1.displayName?.text ?? "Unknown") and \(place2.displayName?.text ?? "Unknown")")
            print("Distance1: \(distance1), Distance2: \(distance2)")
            
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
}
