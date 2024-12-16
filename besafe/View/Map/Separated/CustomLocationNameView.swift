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
   @Binding var enumOverlay: Overlay
   @Binding var showTemporaryMarker: Bool
   @Binding var addingPoint: Bool
   @State var selectedIconID: UUID? = nil
   @State var imgName = "heart.fill"
   @State var color = Color.customRed
   @State var indexStored = 2
   
   var reader: MapProxy
   
   let columns = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
   ]
   
   @EnvironmentObject var pointViewModel: MapPointViewModel
   
   var body: some View {
      ZStack {
         Color.neutral.ignoresSafeArea()
         VStack {
            ModalityTitleView(cancelString: "Cancel", title: "New preferred place", confirmString: "Submit") {
               withAnimation(.easeInOut){
                  onTapAdd = false
                  addingPoint = false
                  showTemporaryMarker = false
                  enumOverlay = .searchPlace
               }
            } submitFunc: {
               let location = reader.convert(CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY), from: .global)
               if let location = location {
                  pointViewModel.add(point: MapPoint(name: searchText, coordinate: location, markerIndex: indexStored))
               }
               
               withAnimation(.easeInOut) {
                  onTapAdd = true
                  addingPoint = false
                  enumOverlay = .customNewPlace
               }
            }
            .padding(.top, 8)
            
            TextfieldWithMarkerView(color: color, img: imgName, textfieldString: $searchText)
            
            LazyVGrid(columns: columns, spacing: 20, content: {
               ForEach(Variables.icons.indices, id: \.self) { index in
                  if index == 4 {
                     Spacer()
                  }
                  
                  MarkerIconView(color: Variables.icons[index].color, img: Variables.icons[index].img)
                     .padding(8)
                     .background(selectedIconID == Variables.icons[index].id ? .neutral : .neutral.opacity(0))
                     .clipShape(Circle())
                     .onTapGesture {
                        selectedIconID = Variables.icons[index].id
                        color = Variables.icons[index].color
                        imgName = Variables.icons[index].img
                        indexStored = index
                     }
                  
                  if index == Variables.icons.count - 1 {
                     Spacer()
                  }
               }
            })
            .padding()
            .background(.customWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Spacer()
         }
         .padding(.horizontal)
      }
      .onAppear(perform: {
         selectedIconID = Variables.icons.first { $0.img == "heart.fill" }?.id
      })
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .shadow(radius: 16, y: 4)
      .frame(maxHeight: .infinity)
   }
}
