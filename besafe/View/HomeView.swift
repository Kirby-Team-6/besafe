//
//  HomeView.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData

struct HomeView: View {
   @Environment(\.modelContext) private var modelContext
   @Query private var markers: [MapPoint]
   
   @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
   
   var body: some View {
      ZStack {
         MapReader { reader in
            VStack {
               Map(position: $position) {
                  UserAnnotation()
                  
                  ForEach(markers, id: \.self) { marker in
                     Marker(marker.name, coordinate: marker.coordinate)
                        .tint(.red)
                  }
               }
               .onAppear {
                  CLLocationManager().requestWhenInUseAuthorization()
               }
               
               Button(action: {
                  let location = reader.convert(CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - 50), from: .local)
                  if let location = location {
                     let newMarker = MapPoint(name: "Place \(markers.count + 1)", coordinate: location)
                     modelContext.insert(newMarker)
                     try? modelContext.save()
                  }
               }, label: {
                  Text("Add Pinpoint")
               })
            }
         }
         
         Image(systemName: "chevron.down")
            .foregroundColor(.red)
            .font(.title)
      }
   }
}

#Preview {
    HomeView()
      .modelContainer(for: MapPoint.self)
}
