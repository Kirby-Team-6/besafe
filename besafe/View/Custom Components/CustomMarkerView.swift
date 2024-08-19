//
//  CustomMarkerView.swift
//  besafe
//
//  Created by Paulus Michael on 18/08/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct CustomMarkerView: View {
   let name: String
   let coordinate: CLLocationCoordinate2D
   @Binding var selectedMarker: MapPoint?
   var marker: MapPoint
   
   var body: some View {
      Image(.customMarker)
         .foregroundColor(selectedMarker == marker ? .blue : .red)
         .scaleEffect(selectedMarker == marker ? 1.2 : 1.0)
         .animation(.spring(), value: selectedMarker == marker)
         .onTapGesture {
            withAnimation {
               selectedMarker = marker
            }
         }
   }
}
