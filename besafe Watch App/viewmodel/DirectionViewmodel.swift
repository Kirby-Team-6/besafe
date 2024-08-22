//
//  DirectionViewmodel.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 21/08/24.
//

import Foundation
import MapKit

class DirectionViewmodel: ObservableObject {
    private let remoteDataSource: RemoteDataSource

    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    
    private var listSafePlaces: [PlaceModel] = []
    var selectedSafePlace: PlaceModel?
    private var loadData = false
    
    func loadCustomPlaces(mapPointViewModel: MapPointViewModel) {
//            self.mapPoints = mapPointViewModel.mapPoint
        }
    
    func getSafePlace() async -> PlaceModel?  {
        if loadData == true && !listSafePlaces.isEmpty  {
            return listSafePlaces.first
        }
        
        self.loadData = true
        guard let location = CLLocationManager().location?.coordinate else {
            return nil
        }
        let result = await remoteDataSource.getNearbyPlaces(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        switch result {
        case .success(let success):
            let data = SafePlaceUtils.sortSafePlaces(success, customPlaces: [], from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            DispatchQueue.main.async {
                self.listSafePlaces = data
                data.forEach{ v in
                    let distance =  SafePlaceUtils.calculateDistance(from: CLLocation(latitude: location.latitude, longitude: location.longitude), to: v)
                    
                    print("\(v.displayName?.text ?? "") | \(v.primaryType) | \(distance)")
                }
                self.loadData = false
            }
        case .failure(let failure):
            print(failure)
            self.loadData = false
        }
        return selectedSafePlace
    }
    
    func stopDirection()  {
//        self.route = nil
        self.selectedSafePlace = nil
    }
    
    func navigateToSafePlace(safePlaces: [PlaceModel], latitude: Double, longitude: Double) {
        self.selectedSafePlace = safePlaces.first
        guard let safePlaces = safePlaces.first?.location else {
            return
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
  
            guard let location = CLLocationManager().location?.coordinate else {
                return
            }
            
            // Reload safe places, excluding the selected place
            let filteredPlaces = listSafePlaces.filter { $0.id != selectedPlace.id }
            let sortedPlaces = SafePlaceUtils.sortSafePlaces(filteredPlaces, customPlaces: [], from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            listSafePlaces = sortedPlaces
            
            
            navigateToSafePlace(safePlaces: sortedPlaces, latitude: location.latitude, longitude: location.longitude)
        }
    }
}
