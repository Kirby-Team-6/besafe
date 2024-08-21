//
//  SafePlaceUtils.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

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
    
    
//    static func sortSafePlaces(_ places: [PlaceModel], from userLocation: CLLocation) -> [PlaceModel] {
//        return places.sorted { (place1, place2) -> Bool in
//            let distance1 = calculateDistance(from: userLocation, to: place1)
//            let distance2 = calculateDistance(from: userLocation, to: place2)
//            
//            let distanceDifference = abs(distance1 - distance2)
//            let distanceTolerance: Double = 10.0
//            
//            if distanceDifference <= distanceTolerance {
//                let priority1 = priorityOrder[place1.primaryType] ?? Int.max
//                let priority2 = priorityOrder[place2.primaryType] ?? Int.max
//                if priority1 != priority2 {
//                    return priority1 < priority2
//                } else {
//                    return place1.id < place2.id
//                }
//            } else {
//                // If distances are not within tolerance, sort by distance
//                return distance1 < distance2
//            }
//            
//        }
//    }
    
    //TODO: Check logic kalau ada custom place
    static func sortSafePlaces(_ places: [PlaceModel], customPlaces: [MapPoint], from userLocation: CLLocation) -> [PlaceModel] {
        // Convert custom places to PlaceModel and combine with the existing places
        var combinedPlaces = places
        
        for customPlace in customPlaces {
            let placeModel = PlaceModel(
                id: UUID().uuidString,
                location: Location(latitude: customPlace.coordinate.latitude, longitude: customPlace.coordinate.longitude),
                currentOpeningHours: nil,
                primaryType: "custom",
                displayName: DisplayName(text: customPlace.name, languageCode: nil),
                shortFormattedAddress: nil 
            )

            combinedPlaces.append(placeModel)
        }
        
        // Sort the combined list
        return combinedPlaces.sorted { (place1, place2) -> Bool in
            let distance1 = calculateDistance(from: userLocation, to: place1)
            let distance2 = calculateDistance(from: userLocation, to: place2)
            
            let distanceDifference = abs(distance1 - distance2)
            let distanceTolerance: Double = 10.0
            
            if distanceDifference <= distanceTolerance {
                // Prioritize custom places first when distances are similar
                if place1.primaryType == "custom" && place2.primaryType != "custom" {
                    return true
                } else if place1.primaryType != "custom" && place2.primaryType == "custom" {
                    return false
                }
                
                // If both or neither are custom, sort by priority
                let priority1 = priorityOrder[place1.primaryType] ?? Int.max
                let priority2 = priorityOrder[place2.primaryType] ?? Int.max
                if priority1 != priority2 {
                    return priority1 < priority2
                } else {
                    return place1.id < place2.id
                }
            } else {
                // Sort by distance when not within the tolerance
                return distance1 < distance2
            }
        }
    }

    
    static func calculateDistance(from userLocation: CLLocation, to place: PlaceModel) -> Double {
        let placeLocation = CLLocation(latitude: place.location!.latitude!, longitude: place.location!.longitude!)
        return userLocation.distance(from: placeLocation)
    }
    
    
}
