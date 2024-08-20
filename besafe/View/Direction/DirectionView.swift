//
//  DirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit

struct DirectionView: View {
//    @EnvironmentObject private var router: Router
    @EnvironmentObject private var viewmodel: MainViewModel
    @StateObject private var locationManager = LocationManager()
    
    @Binding var position: MapCameraPosition
    @State private var selection = 0
    @State private var tabViewCount = 0
    @State private var completeRoute = false
    
    var body: some View {
        VStack{
            if (viewmodel.route != nil){
                HeaderDirectionView(selection: $selection, tabViewCount: $tabViewCount)
            }
            
            Spacer()
            HStack {
                Button {
                    position = .userLocation(fallback: .automatic)
                } label: {
                    Image(systemName: "location.fill.viewfinder")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(.background35)
                        .foregroundColor(.blue)
                        .clipShape(Circle())

                        .shadow(radius: 4, x: 0, y: 4)
                    
                }
                Spacer()
            }
            .padding()
            
            if (viewmodel.route != nil) {
                FooterDirectionView()
            }
        }
        .onReceive(locationManager.$location){ location in
            if location == nil {
                return
            }
            if let route = viewmodel.route  {
                guard let lastStep2d = route.steps.last?.polyline.coordinate else {
                    return
                }
                let lastStep = CLLocation(latitude: lastStep2d.latitude, longitude: lastStep2d.longitude)
                let distance = lastStep.distance(from: location!)
                if distance <= 10 {
                    self.completeRoute = true
                }
            }
        }
        .onChange(of: selection){  old, newValue in
            let data = viewmodel.route!.steps[newValue]
            position = .camera(.init(centerCoordinate: data.polyline.coordinate, distance: 700))
        }
        .onReceive(viewmodel.$route) { v in
            if (v != nil){
                tabViewCount = v!.steps.count
            }
        }
    }
}
