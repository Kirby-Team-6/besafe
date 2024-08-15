//
//  DirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit

struct DirectionView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewmodel: DirectionViewmodel
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    var body: some View {
        VStack {
            Map(position: $position){
                UserAnnotation()
                if viewmodel.route != nil {
                    MapPolyline(viewmodel.route!)
                        .stroke(.red, lineWidth: 10)
                }
            }
            .onAppear{
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .onChange(of: position){ old, new in
                if new.region != nil {
                    viewmodel.updateRegion(with: new.region!)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    print("Update")
                    viewmodel.getDirections( to: CLLocationCoordinate2D(latitude: 37.77987026641195, longitude:-122.41349453609541))
                }

            }
            List(viewmodel.directions, id: \.self) { direction in
                Text(direction)
            }
            
        }
    }
}

#Preview {
    DirectionView()
}
