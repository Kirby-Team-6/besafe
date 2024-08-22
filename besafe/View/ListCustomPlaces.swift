//
//  ListCustomPlaces.swift
//  besafe
//
//  Created by Paulus Michael on 22/08/24.
//

import SwiftUI
import MapKit

struct ListCustomPlaces: View {
   @Binding var enumOverlay: Overlay
   @State private var searchText: String = ""
   @State private var searchResults: [MKMapItem] = []
   @State private var isSearching: Bool = false
   @EnvironmentObject var mapPointVM: MapPointViewModel
    @EnvironmentObject var router: Router
   
   var body: some View {
      ZStack{
         Color.neutral.ignoresSafeArea()
         VStack(spacing: 16) {
            ModalityTitleView(cancelString: "Cancel", title: "Custom safe place", confirmString: "+ new") {
                router.pop()
            } submitFunc: {
               withAnimation{
                  enumOverlay = .searchPlace
               }
            }
            
            HStack{
               Text("Your custom safe places")
                  .font(.subheadline)
                  .fontWeight(.semibold)
                  .opacity(0.5)
               
               Spacer()
            }
               
            if !mapPointVM.mapPoint.isEmpty{
               List {
                  ForEach(mapPointVM.mapPoint) { place in
                     HStack {
                        MarkerIconView(color: Variables.icons[place.markerIndex].color, img: Variables.icons[place.markerIndex].img)
                        
                        Text(place.name)
                           .font(.headline)
                     }
                  }
               }
               .clipShape(RoundedRectangle(cornerRadius: 25))
               .listStyle(PlainListStyle())
               
            }
         }
         .padding()
      }
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .shadow(radius: 16, y: 4)
   }
}

//#Preview {
//    ListCustomPlaces()
//}
