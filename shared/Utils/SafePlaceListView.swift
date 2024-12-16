//
//  SafePlaceListView.swift
//  besafe
//
//  Created by Natasha Hartanti Winata on 22/08/24.
//

// MARK: View for testing SafePlaceUtils Logic

import SwiftUI
import CoreLocation

struct SafePlaceListView: View {
    @State private var sortedPlaces: [PlaceModel] = []
    
    let userLocation = CLLocation(latitude: -6.200000, longitude: 106.816666) // User's location
    
    var body: some View {
        VStack {
            Text("Sorted Safe Places")
                .font(.headline)
            
            List(sortedPlaces, id: \.id) { place in
                VStack(alignment: .leading) {
                    Text(place.displayName?.text ?? "Unknown")
                        .font(.subheadline)
                    Text(place.shortFormattedAddress ?? "Unknown Address")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if let distance = calculateDistance(from: userLocation, to: place) {
                        Text(String(format: "%.2f meters away", distance))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            let dummyPlaces = DummyData.createDummyPlaces()
            let dummyCustomPlaces = DummyData.createDummyCustomPlaces()
            
            sortedPlaces = SafePlaceUtils.sortSafePlaces(dummyPlaces, customPlaces: dummyCustomPlaces, from: userLocation)
        }
    }
    
    func calculateDistance(from userLocation: CLLocation, to place: PlaceModel) -> Double? {
        guard let location = place.location else { return nil }
        let placeLocation = CLLocation(latitude: location.latitude!, longitude: location.longitude!)
        return userLocation.distance(from: placeLocation)
    }
}

struct SafePlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        SafePlaceListView()
    }
}

struct OpeningHours {
    let openNow: Bool
}



import Foundation
import CoreLocation

class DummyData {
    static func createDummyPlaces() -> [PlaceModel] {
        return [
            PlaceModel(id: "1", location: Location(latitude: -6.200000, longitude: 106.816666), currentOpeningHours: CurrentOpeningHours(openNow: false), primaryType: "police", displayName: DisplayName(text: "Police Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "2", location: Location(latitude: -6.214621, longitude: 106.84513), currentOpeningHours: CurrentOpeningHours(openNow: false), primaryType: "fire_station", displayName: DisplayName(text: "Fire Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "3", location: Location(latitude: -6.217, longitude: 106.83), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "hospital", displayName: DisplayName(text: "Hospital", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "4", location: Location(latitude: -6.22, longitude: 106.82), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "hotel", displayName: DisplayName(text: "Hotel", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "5", location: Location(latitude: -6.18, longitude: 106.82), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "convenience_store", displayName: DisplayName(text: "Convenience Store", languageCode: "en"), shortFormattedAddress: "Jakarta")
        ]
    }
    
    static func createDummyCustomPlaces() -> [MapPoint] {
        return [
            MapPoint(name: "Custom Place 1", coordinate: CLLocationCoordinate2D(latitude: -6.22, longitude: 106.85), markerIndex: 0),
            MapPoint(name: "Custom Place 2", coordinate: CLLocationCoordinate2D(latitude: -6.22, longitude: 106.813), markerIndex: 0)
        ]
    }
}
