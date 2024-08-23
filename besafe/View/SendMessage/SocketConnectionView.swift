//
//  SocketConnectionView.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 22/08/24.
//

import SwiftUI

struct SocketConnectionView: View {
    @StateObject private var locationManager = LiveTrackingViewModel()
    private let socketHelper: SocketHelper

    init() {
        // Generate a session ID when the view is initialized
        let sessionId = generateSessionID()
        self.socketHelper = SocketHelper(sessionId: sessionId)
    }

    var body: some View {
        VStack {
            Text("Live Tracking")
                .font(.largeTitle)
                .padding()
        }
        .onAppear {
            locationManager.startUpdatingLocation()
            locationManager.onLocationUpdate = { location in
                // Send location updates to the socket
                self.socketHelper.sendLocationUpdate(latitude: location.latitude, longitude: location.longitude)
            }
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
            socketHelper.disconnectSocket()
        }
    }
}

//#Preview {
//    SocketConnectionView()
//}
