//
//  TestSocketView.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 21/08/24.
//

import SwiftUI

struct TestSocketView: View {
    @StateObject private var viewModel: SocketIOViewModel
    @State private var isTracking = false

    init(socketURL: String, locationService: LocationManager) {
        _viewModel = StateObject(wrappedValue: SocketIOViewModel(socketURL: socketURL, locationService: locationService))
    }

    var body: some View {
        VStack {
            if let location = viewModel.location {
                Text("Latitude: \(location.coordinate.latitude)")
                Text("Longitude: \(location.coordinate.longitude)")
            } else {
                Text("Fetching location...")
            }
            
            Button(action: {
                if isTracking {
                    viewModel.stopTracking()
                } else {
                    viewModel // triggers the view model to start tracking
                }
                isTracking.toggle()
            }) {
                Text(isTracking ? "Stop Tracking" : "Start Tracking")
                    .padding()
                    .background(isTracking ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onDisappear {
            if isTracking {
                viewModel.stopTracking()
            }
        }
    }
}

//#Preview {
//    TestSocketView(socketURL: <#String#>, locationService: <#LocationManager#>)
//}
