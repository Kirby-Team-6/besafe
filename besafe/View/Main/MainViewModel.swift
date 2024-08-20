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
    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    @Published var route: MKRoute?
    @Published var coverScreen = CoverScreen.initial
    @Published var listSafePlaces: [PlaceModel] = []
    private var task: Task<Void, Never>?
    
    func getSafePlace() {
        if task?.isCancelled == false {
            return
        }
        task = Task {
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
                    print(data.count)
                }
                navigateToSafePlace(latitude: location.latitude, longitude: location.longitude)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func navigateToSafePlace(latitude: Double, longitude: Double) {
        guard let safePlaces = listSafePlaces.first?.location else {
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
        }
    }
    
}
