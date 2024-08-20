//
//  MainView.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct MainView: View {
    @StateObject var viewmodel = DI.shared.mainViewmodel()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showInitialView = true
    @State private var showCompleteDirection = false
    @State private var loadMap = false
    
    var body: some View {
        ZStack {
            if loadMap {
                Map(position: $position){
                    UserAnnotation()
                    if viewmodel.route != nil {
                        let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                        MapPolyline(viewmodel.route!)
                            .stroke(Color.blue, style: strokeStyle)
                    }
                }
                DirectionView(position: $position)
            }
        }
        .fullScreenCover(isPresented: $showCompleteDirection) {
            ComplateDirectionView(onReroute: {}, onDone: {
                self.showCompleteDirection = false
                self.showInitialView = true
            })
                .background(BackgroundBlurView())
                .ignoresSafeArea(.all, edges: .all)
        }
        .fullScreenCover(isPresented: $showInitialView) {
            EmergencyPageView {
                self.showInitialView = false
                if let cordinate = CLLocationManager().location?.coordinate {
                    viewmodel.navigateToSafePlace(latitude: cordinate.latitude, longitude: cordinate.longitude)
                }
            }
            .frame(maxWidth: .infinity)
            .background(BackgroundBlurView())
            .ignoresSafeArea(.all, edges: .all)
            .onAppear {
                self.loadMap = true
            }
        }
        .environmentObject(viewmodel)
    }
}

#Preview {
    MainView()
}
