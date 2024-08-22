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
    
    private var listSafePlaces: [PlaceModel] = []
    private var selectedSafePlace: PlaceModel?
    private var loadData = false
    
    func getSafePlace() {
        if loadData == true && !listSafePlaces.isEmpty {
            return
        }
        Task {
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
                let data = SafePlaceUtils.sortSafePlaces(success, from: CLLocation(latitude: location.latitude, longitude: location.longitude))
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
