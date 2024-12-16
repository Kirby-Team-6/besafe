//
//  SearchNearbyViewModel.swift
//  besafe
//
//  Created by Natasha Hartanti Winata on 18/08/24.
//

import SwiftUI
import CoreLocation
import MapKit

class SearchNearby: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var nearbyPlaces: [NearbyPlace] = []
    @Published var userLocation: CLLocation?
    
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location // Update userLocation
            searchNearbyPlaces(at: location.coordinate)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func searchNearbyPlaces(at coordinate: CLLocationCoordinate2D) {
        nearbyPlaces.removeAll()
        
        // Phase 1: Use MKLocalPointsOfInterestRequest
        searchPOIPlaces(at: coordinate) {
            // Phase 2: Use MKLocalSearch for fallback categories not covered by POI
            self.searchFallbackPlaces(at: coordinate)
        }
    }
    
    private func searchPOIPlaces(at coordinate: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        let request = MKLocalPointsOfInterestRequest(center: coordinate, radius: 1000)
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [
            .hospital, .gasStation, .hotel, .police, .university
        ])
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response else {
                print("POI Search error: \(error?.localizedDescription ?? "Unknown error")")
                completion()
                return
            }
            
            let places = response.mapItems.compactMap { item -> NearbyPlace? in
                guard let name = item.name,
                      let address = item.placemark.title,
                      let coordinate = item.placemark.location?.coordinate else {
                    return nil
                }
                
                let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) / 1000
                
                return NearbyPlace(name: name, address: address, distance: distance, coordinate: coordinate)
            }
            
            DispatchQueue.main.async {
                self?.nearbyPlaces.append(contentsOf: places)
                completion()
            }
        }
    }
    
    private func searchFallbackPlaces(at coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Mall, Mosque, Church, Vihara, Pura"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response else {
                print("Fallback search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let places = response.mapItems.compactMap { item -> NearbyPlace? in
                guard let name = item.name,
                      let address = item.placemark.title,
                      let coordinate = item.placemark.location?.coordinate else {
                    return nil
                }
                
                let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) / 1000
                
                return NearbyPlace(name: name, address: address, distance: distance, coordinate: coordinate)
            }
            
            DispatchQueue.main.async {
                self?.nearbyPlaces.append(contentsOf: places)
            }
        }
    }
}

