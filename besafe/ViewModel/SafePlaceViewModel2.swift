//import Foundation
//import SwiftUI
//import CoreLocation
//
//class SafePlaceViewModel: ObservableObject {
//    @Published var safePlaces: [SafePlace] = []
//
//    func loadPlaces() {
//        guard let url = Bundle.main.url(forResource: "places", withExtension: "json") else {
//            print("Failed to locate JSON file.")
//            return
//        }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            let placesResponse = try decoder.decode(PlacesResponse.self, from: data)
//            self.safePlaces = placesResponse.places.map { place in
//                SafePlace(
//                    id: place.id,
//                    name: place.displayName.text,
//                    types: place.primaryType,
//                    location: SafePlace.Location(latitude: place.location.latitude, longitude: place.location.longitude),
//                    address: place.shortFormattedAddress,
//                    openNow: place.currentOpeningHours?.openNow ?? false
//                )
//            }
//        } catch {
//            print("Failed to decode JSON: \(error.localizedDescription)")
//        }
//    }
//}
//
//// Data model for decoding the updated JSON structure
//struct PlacesResponse: Codable {
//    let places: [Place]
//    
//    struct Place: Codable {
//        let id: String
//        let location: Location
//        let displayName: DisplayName
//        let primaryType: String
//        let shortFormattedAddress: String
//        let currentOpeningHours: CurrentOpeningHours?
//
//        struct Location: Codable {
//            let latitude: Double
//            let longitude: Double
//        }
//
//        struct DisplayName: Codable {
//            let text: String
//        }
//
//        struct CurrentOpeningHours: Codable {
//            let openNow: Bool?
//        }
//    }
//}
//
//
//struct ContentView2: View {
//    @StateObject private var viewModel = SafePlaceViewModel()
//    
//    var body: some View {
//        List(viewModel.safePlaces) { place in
//            VStack(alignment: .leading) {
//                Text(place.name)
//                    .font(.headline)
//                Text(place.types)
//                Text(place.address)
//                Text(place.openNow ? "Open Now" : "Closed")
//            }
//        }
//        .onAppear {
//            viewModel.loadPlaces()
//        }
//    }
//}
//
//#Preview {
//    ContentView2()
//}
