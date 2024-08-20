//
//  TemporaryInitialViewmodel.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import Foundation
import CoreLocation

class TemporaryInitialViewmodel: ObservableObject {
    private let remoteDataSource: RemoteDataSource
    
    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getNearbyPlace(latitude: Double, longitude: Double)  {
        Task {
            let result = await remoteDataSource.getNearbyPlaces(latitude, longitude: longitude)
            switch result {
            case .success(let success):
                let sortedPlaces = sortSafePlaces(success, from: userLocation)
                
                sortedPlaces.forEach { v in
                    print(v.displayName?.text)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @Published var safePlaces: [PlaceModel] = []
    @Published var selectedSafePlace: PlaceModel?
    
    private var userLocation: CLLocation = CLLocation(latitude: -6.200000, longitude: 106.816666)
    private var excludedPlace: PlaceModel?
    private var exclusionTimestamp: Date?
    
    private let priorityOrder: [String: Int] = [
        // TODO: Tambahin custom safe place nya user yang jadi priority 1
        "police": 1,
        "fire_station": 1,
        "hospital": 2,
        "hotel": 3,
        "resort_hotel": 3,
        "bank": 4,
        "convenience_store": 4,
        "gas_station": 5,
        "shopping_mall": 6,
        "supermarket": 6,
        "department_store": 6,
        "university": 7,
        "church": 8,
        "hindu_temple": 9,
        "mosque": 10,
        "synagogue": 11
    ]
            
    private func calculateDistance(from userLocation: CLLocation, to place: PlaceModel) -> Double {
        let placeLocation = CLLocation(latitude: place.location!.latitude!, longitude: place.location!.longitude!)
        return userLocation.distance(from: placeLocation)
    }
    
    private func sortSafePlaces(_ places: [PlaceModel], from userLocation: CLLocation) -> [PlaceModel] {
        return places.sorted { (place1, place2) -> Bool in
            let distance1 = calculateDistance(from: userLocation, to: place1)
            let distance2 = calculateDistance(from: userLocation, to: place2)
            
            if distance1 != distance2 {
                return distance1 < distance2
            } else {
                let priority1 = priorityOrder[place1.primaryType] ?? Int.max
                let priority2 = priorityOrder[place2.primaryType] ?? Int.max
                return priority1 < priority2
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
            let filteredPlaces = safePlaces.filter { $0.id != selectedPlace.id }
            let sortedPlaces = sortSafePlaces(filteredPlaces, from: userLocation)
            safePlaces = sortedPlaces
            
            // Select the next top place
            selectTopSafePlace()
        }
    }
    
    func distanceToPlace(_ place: PlaceModel) -> Double {
        return calculateDistance(from: userLocation, to: place)
    }
    
    func shouldExcludePlace(_ place: PlaceModel) -> Bool {
        if let excludedPlace = excludedPlace, let exclusionTimestamp = exclusionTimestamp {
            let timeInterval = Date().timeIntervalSince(exclusionTimestamp)
            let twelveHours: TimeInterval = 12 * 60 * 60
            
            // Check if the exclusion period (12 hours) has passed
            if timeInterval < twelveHours {
                return place.id == excludedPlace.id
            } else {
                // Reset exclusion after 12 hours
                self.excludedPlace = nil
                self.exclusionTimestamp = nil
            }
        }
        return false
    }
}
