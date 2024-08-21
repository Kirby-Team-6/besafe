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
   @EnvironmentObject var pointViewModel: MapPointViewModel
   @State var mapSelection: MapPoint?
   @State var showingLocationDetail = false
   
   @StateObject var connect = WatchConnect()
   
   var body: some View {
      ZStack {
         Map(position: $position, selection: $mapSelection) {
            UserAnnotation()
         }
         
         VStack {
            Text(connect.text1)
            Text(connect.text2)
            
            HStack {
               Button {
                  connect.increment()
               } label: {
                  Text("Testing 1")
               }
               
               Button {
                  connect.decrement()
               } label: {
                  Text("Testing 1")
               }
            }
         }
         .frame(maxHeight: .infinity, alignment: .bottom)
      }
   }
}

#Preview {
   ContentView()
}
