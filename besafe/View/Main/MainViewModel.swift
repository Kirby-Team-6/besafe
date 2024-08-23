//
//  MainViewModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import Foundation
import MapKit

enum CoverScreen {
    case direction
    case complete
    case initial
    case none
}

class MainViewModel: ObservableObject {
    private let remoteDataSource: RemoteDataSource
    private let swiftDataSource: SwiftDataService

    init(remoteDataSource: RemoteDataSource, swiftDataSource: SwiftDataService) {
        self.remoteDataSource = remoteDataSource
        self.swiftDataSource = swiftDataSource
    }
    
    @Published var route: MKRoute?
    @Published var coverScreen = CoverScreen.initial
    
    var listSafePlaces: [PlaceModel] = []
    var selectedSafePlace: PlaceModel?
    private var loadData = false
    
    func getSafePlace(mapPointViewModel: MapPointViewModel) {
        if loadData == true && !listSafePlaces.isEmpty  {
            return
        }
        Task {
            let customSafePlace = swiftDataSource.fetchMapPoints()
            self.loadData = true
            guard let location = CLLocationManager().location?.coordinate else {
                return
            }
            let result = await remoteDataSource.getNearbyPlaces(
                latitude: location.latitude,
                longitude: location.longitude
            )
            
            
            switch result {
            case .success(let success):
                var mutableData = success
                customSafePlace.forEach{
                    let placeModel = PlaceModel(
                        id: UUID().uuidString,
                        location: Location(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                        currentOpeningHours: CurrentOpeningHours(openNow: true),
                        primaryType: "custom",
                        displayName: DisplayName(text: $0.name, languageCode: nil),
                        shortFormattedAddress: nil
                    )
                    mutableData.append(placeModel)
                }
                let data = SafePlaceUtils.sortSafePlaces(mutableData, from: CLLocation(latitude: location.latitude, longitude: location.longitude))
                DispatchQueue.main.async {
                    self.listSafePlaces = data
                    data.forEach{ v in
                        let distance =  SafePlaceUtils.calculateDistance(from: CLLocation(latitude: location.latitude, longitude: location.longitude), to: v)

                        print("\(v.displayName?.text ?? "") | \(v.primaryType) | \(distance)")
                    }
                    self.loadData = false
                }
                navigateToSafePlace(safePlaces: data, latitude: location.latitude, longitude: location.longitude)
            case .failure(let failure):
                print(failure)
                self.loadData = false
            }
        }
    }
    
    func stopDirection()  {
        self.route = nil
        self.selectedSafePlace = nil
    }
    
    func navigateToSafePlace(safePlaces: [PlaceModel], latitude: Double, longitude: Double) {
        self.selectedSafePlace = safePlaces.first
        guard let safePlaces = safePlaces.first?.location else {
            return
        }
        let source = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let destination = CLLocationCoordinate2D(latitude: safePlaces.latitude!,longitude:  safePlaces.longitude!)
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
            CLLocationManager().startUpdatingLocation()
        }
    }
    
    // TODO: Selected top safe place
//    private func selectTopSafePlace() {
//        if !safePlaces.isEmpty {
//            selectedSafePlace = safePlaces.first
//        }
//    }
    func selectTopSafePlace() {
        // Ensure the list is not empty
        guard let topSafePlace = listSafePlaces.first else {
            print("No safe places available.")
            return
        }
        
        // Set the selectedSafePlace to the top place
        selectedSafePlace = topSafePlace
    }

    
    func reroute() {
        if let selectedPlace = selectedSafePlace {
            // Exclude the current selected place for 12 hours
            swiftDataSource.addExcludePlace(ExcludePlaceModel(id: selectedPlace.id, timeStamp: Date()))
            
            guard let location = CLLocationManager().location?.coordinate else {
                return
            }
            
            // Reload safe places, excluding the selected place
            let filteredPlaces = listSafePlaces.filter { $0.id != selectedPlace.id }
            let sortedPlaces = SafePlaceUtils.sortSafePlaces(filteredPlaces, from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            listSafePlaces = sortedPlaces
            
        
            navigateToSafePlace(safePlaces: sortedPlaces, latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    func shouldExcludePlace(_ place: PlaceModel) -> Bool {
//        if let excludedPlace = excludedPlace, let exclusionTimestamp = exclusionTimestamp {
//            let timeInterval = Date().timeIntervalSince(exclusionTimestamp)
//            let twelveHours: TimeInterval = 12 * 60 * 60
//            
//            // Check if the exclusion period (12 hours) has passed
//            if timeInterval < twelveHours {
//                return place.name == excludedPlace.name
//            } else {
//                // Reset exclusion after 12 hours
//                self.excludedPlace = nil
//                self.exclusionTimestamp = nil
//            }
//        }
        return false
    }
    
}
