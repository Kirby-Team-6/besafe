//
//  CustomLocationNameView.swift
//  besafe
//
//  Created by Paulus Michael on 17/08/24.
//

import SwiftUI
import MapKit

struct CustomLocationNameView: View {
   @Binding var searchText: String
   @Binding var onTapAdd: Bool
   @Binding var addingPoint: Bool
   var reader: MapProxy
   
   @EnvironmentObject var pointViewModel: MapPointViewModel
   
   var body: some View {
      ZStack {
         Color.neutral.ignoresSafeArea()
         VStack {
            ModalityTitleView(cancelString: "Cancel", title: "New preferred place", confirmString: "Submit") {
               withAnimation(.easeInOut){
                  onTapAdd = false
                  addingPoint = false
               }
            } submitFunc: {
               let location = reader.convert(CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY), from: .global)
               if let location = location {
                  pointViewModel.add(point: MapPoint(name: searchText, coordinate: location))
               }
               
               withAnimation(.easeInOut) {
                  onTapAdd = true
                  addingPoint = false
               }
            }
            .padding(.top, 8)
            
            TextField("Enter Marker Name", text: $searchText)
               .padding()
               .background(.white)
               .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Spacer()
         }
         .padding(.horizontal)
      }
      //      .frame(height: UIScreen.main.bounds.height * 0.3)
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .offset(y: addingPoint ? 0 : UIScreen.main.bounds.height)
      .shadow(radius: 16, y: 4)
   }
}
