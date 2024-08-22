//
//  SocketIOViewModel.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 21/08/24.
//

import Foundation
import Combine
import CoreLocation

class SocketIOViewModel: ObservableObject {
    @Published var location: CLLocation?
    @Published var status: CLAuthorizationStatus?

    private let socketService: SocketService
    private let locationService: LocationManager
    private var cancellables = Set<AnyCancellable>()
    private var sessionId: String?

    init(socketService: SocketService, locationService: LocationManager) {
        self.socketService = socketService
        self.locationService = locationService
        print("SocketIOViewModel initialized")
        setupBindings()
    }
    
    convenience init(socketURL: String, locationService: LocationManager) {
        let socketService = SocketIOManager(baseURL: socketURL)
        print("SocketIOViewModel convenience init called")
        self.init(socketService: socketService, locationService: locationService)
    }

    private func setupBindings() {
        // Generate session ID using the utility function
        sessionId = generateSessionID()
        
        // Establish Socket.io connection
        if let sessionId = sessionId {
            socketService.establishConnection(withSessionId: sessionId)
        }

        // Bind location updates
        locationService.$location
            .sink { [weak self] location in
                self?.location = location
                self?.sendLocationToServer(location)
            }
            .store(in: &cancellables)
        
        // Bind authorization status updates
        locationService.$status
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }

    private func sendLocationToServer(_ location: CLLocation?) {
        guard let location = location, let sessionId = sessionId else { return }
        socketService.sendLocationUpdate(
            sessionId: sessionId,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }

    func stopTracking() {
        socketService.disconnect()
        locationService.stopUpdatingLocation()
    }
}
