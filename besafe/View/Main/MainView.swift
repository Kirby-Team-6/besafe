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
    @StateObject var viewmodel = MainViewModel()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        ZStack {
            Map(position: $position){
                UserAnnotation()
                if viewmodel.route != nil {
                    let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    MapPolyline(viewmodel.route!)
                        .stroke(Color.blue, style: strokeStyle)
                }
            }

        }
    }
}

#Preview {
    MainView()
}
