//
//  ContentView.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
   @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
   var body: some View {
      Map(position: $position){
         UserAnnotation()
      }
      .onAppear{
         CLLocationManager().requestWhenInUseAuthorization()
      }
   }
}

#Preview {
    ContentView()
}
