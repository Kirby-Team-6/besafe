import Foundation
import CoreLocation

class SafePlacesViewModel: ObservableObject {
   @Published var safePlaces: [SafePlace] = []
   private var userLocation: CLLocation = CLLocation(latitude: -6.200000, longitude: 106.816666)
   
   private let priorityOrder: [String: Int] = [
      "police_station": 1,
      "hospital": 2,
      "hotel": 3,
      "convenience_store": 4,
      "gas_station": 5,
      "shopping_mall": 6,
      "university": 7,
      "place_of_worship": 8
   ]
   
   func loadSafePlaces() {
      if let jsonData = loadJSONDataFromFile(named: "GoogleMapsData") {
         if let loadedPlaces = loadSafePlaces(from: jsonData) {
            let sortedPlaces = sortSafePlaces(loadedPlaces, from: userLocation)
            self.safePlaces = sortedPlaces
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
   
   private func sortSafePlaces(_ places: [SafePlace], from userLocation: CLLocation) -> [SafePlace] {
      return places.sorted { (place1, place2) -> Bool in
         let distance1 = calculateDistance(from: userLocation, to: place1)
         let distance2 = calculateDistance(from: userLocation, to: place2)
         
         if distance1 != distance2 {
            return distance1 < distance2
         } else {
            let priority1 = priorityOrder[place1.types.first ?? ""] ?? Int.max
            let priority2 = priorityOrder[place2.types.first ?? ""] ?? Int.max
            return priority1 < priority2
         }
      }
   }
   
   func distanceToPlace(_ place: SafePlace) -> Double {
      return calculateDistance(from: userLocation, to: place)
   }
}
