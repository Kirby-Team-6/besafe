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
        .onReceive(viewmodel.$coverScreen){ v in
            self.showInitialView = false
            self.showCompleteDirection = false
            
            switch v {
            case .direction:
                ""
            case .complete:
                self.showCompleteDirection = true
            case .initial:
                self.showInitialView = true
            case .none:
                ""
            }
        }
        .fullScreenCover(isPresented: $showCompleteDirection) {
            ComplateDirectionView(onReroute: {}, onDone: {
                viewmodel.coverScreen = CoverScreen.initial
            })
                .background(BackgroundBlurView())
                .ignoresSafeArea(.all, edges: .all)
        }
        .fullScreenCover(isPresented: $showInitialView) {
            EmergencyPageView {
                viewmodel.coverScreen = CoverScreen.direction
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

//#Preview {
//    MainView()
//}
