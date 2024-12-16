//
//  SocketSendLocationViewModel.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 22/08/24.
//

import Foundation
import CoreLocation

class SocketSendLocationViewModel: NSObject, CLLocationManagerDelegate {

    static let shared = SocketSendLocationViewModel()
    private var locationManager: CLLocationManager!

    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        // Send location update to the SocketManager
        SocketHandler.shared.sendLocationUpdate(latitude: latitude, longitude: longitude)
    }
}
