import Foundation
import CoreLocation

class SafePlacesViewModel: ObservableObject {
    @Published var safePlaces: [SafePlace] = []
    @Published var selectedSafePlace: SafePlace?
    
    private var userLocation: CLLocation = CLLocation(latitude: -6.200000, longitude: 106.816666)
    private var excludedPlace: SafePlace?
    private var exclusionTimestamp: Date?
    
    private let priorityOrder: [String: Int] = [
        // TODO: Tambahin custom safe place nya user yang jadi priority 1
            "police": 1,
            "hospital": 2,
            "hotel": 3,
            "resort_hotel": 3,
            "bank": 4,
            "fire_station": 5,
            "convenience_store": 6,
            "supermarket": 6,
            "gas_station": 7,
            "shopping_mall": 8,
            "department_store": 8,
            "university": 9,
            "hindu_temple": 10,
            "mosque": 10,
            "synagogue": 10,
            "church": 10
    ]
    
    func loadSafePlaces() {
        if let jsonData = loadJSONDataFromFile(named: "GoogleMapsData") {
            if let loadedPlaces = loadSafePlaces(from: jsonData) {
                let sortedPlaces = sortSafePlaces(loadedPlaces, from: userLocation)
                self.safePlaces = sortedPlaces
                selectTopSafePlace()
            }
        }
    }
    
    private func loadJSONDataFromFile(named fileName: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                print("Error loading JSON from file: \(error)")
            }
        }
        return nil
    }
    
    private func loadSafePlaces(from jsonData: Data) -> [SafePlace]? {
        let decoder = JSONDecoder()
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            if let results = jsonObject?["results"] as? [[String: Any]] {
                let jsonData = try JSONSerialization.data(withJSONObject: results, options: [])
                let safePlaces = try decoder.decode([SafePlace].self, from: jsonData)
                return safePlaces
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
    
    private func calculateDistance(from userLocation: CLLocation, to place: SafePlace) -> Double {
        let placeLocation = CLLocation(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
        return userLocation.distance(from: placeLocation)
    }
    
//    private func sortSafePlaces(_ places: [SafePlace], from userLocation: CLLocation) -> [SafePlace] {
//        return places.sorted { (place1, place2) -> Bool in
//            let distance1 = calculateDistance(from: userLocation, to: place1)
//            let distance2 = calculateDistance(from: userLocation, to: place2)
//            
//            if distance1 != distance2 {
//                return distance1 < distance2
//            } else {
//                let priority1 = priorityOrder[place1.types.first ?? ""] ?? Int.max
//                let priority2 = priorityOrder[place2.types.first ?? ""] ?? Int.max
//                return priority1 < priority2
//            }
//        }
//    }
    
    private func sortSafePlaces(_ places: [SafePlace], from userLocation: CLLocation) -> [SafePlace] {
        return places.sorted { (place1, place2) -> Bool in
            let distance1 = calculateDistance(from: userLocation, to: place1)
            let distance2 = calculateDistance(from: userLocation, to: place2)
            
            let distanceDifference = abs(distance1 - distance2)
            let distanceTolerance: Double = 10.0 // 10 meter tolerance

            if distanceDifference <= distanceTolerance {
                // If distances are within tolerance, sort by priority
                let priority1 = priorityOrder[place1.types.first ?? ""] ?? Int.max
                let priority2 = priorityOrder[place2.types.first ?? ""] ?? Int.max
                
                if priority1 != priority2 {
                    return priority1 < priority2
                } else {
                    // If priority is the same, sort alphabetically by name
                    return place1.name < place2.name
                }
            } else {
                // If distances are not within tolerance, sort by distance
                return distance1 < distance2
            }
        }
    }

    
    private func selectTopSafePlace() {
        if !safePlaces.isEmpty {
            selectedSafePlace = safePlaces.first
        }
    }
    
    func reroute() {
        if let selectedPlace = selectedSafePlace {
            // Exclude the current selected place for 12 hours
            excludedPlace = selectedPlace
            exclusionTimestamp = Date()
            
            // Reload safe places, excluding the selected place
            let filteredPlaces = safePlaces.filter { $0.name != selectedPlace.name }
            let sortedPlaces = sortSafePlaces(filteredPlaces, from: userLocation)
            safePlaces = sortedPlaces
            
            // Select the next top place
            selectTopSafePlace()
        }
    }
    
    func distanceToPlace(_ place: SafePlace) -> Double {
        return calculateDistance(from: userLocation, to: place)
    }
    
    func shouldExcludePlace(_ place: SafePlace) -> Bool {
        if let excludedPlace = excludedPlace, let exclusionTimestamp = exclusionTimestamp {
            let timeInterval = Date().timeIntervalSince(exclusionTimestamp)
            let twelveHours: TimeInterval = 12 * 60 * 60
            
            // Check if the exclusion period (12 hours) has passed
            if timeInterval < twelveHours {
                return place.name == excludedPlace.name
            } else {
                // Reset exclusion after 12 hours
                self.excludedPlace = nil
                self.exclusionTimestamp = nil
            }
        }
        return false
    }
}
