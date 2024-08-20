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
   @State var selectedIconID: UUID? = nil
   
   var reader: MapProxy
   
   let columns = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
   ]
   
   let icons = [
      MarkerIcon(color: .customCyan, img: "house.fill"),
      MarkerIcon(color: .customOrange, img: "briefcase.fill"),
      MarkerIcon(color: .customRed, img: "heart.fill"),
      MarkerIcon(color: .customBlue, img: "graduationcap.fill"),
      MarkerIcon(color: .customGreen, img: "tree.fill"),
      MarkerIcon(color: .customIndigo, img: "storefront.fill")
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
            
            TextfieldWithMarkerView(color: .red, img: "heart.fill", textfieldString: $searchText)
            
            LazyVGrid(columns: columns, spacing: 20, content: {
               ForEach(icons.indices, id: \.self) { index in
                  if index == 4 {
                     Spacer()
                  }
                  
                  MarkerIconView(color: icons[index].color, img: icons[index].img)
                     .padding(8)
                     .background(selectedIconID == icons[index].id ? .neutral : .neutral.opacity(0))
                     .clipShape(Circle())
                     .onTapGesture {
                        selectedIconID = icons[index].id
                     }
                  
                  if index == icons.count - 1 {
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
      //      .frame(height: UIScreen.main.bounds.height * 0.3)
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .offset(y: addingPoint ? 0 : UIScreen.main.bounds.height)
      .shadow(radius: 16, y: 4)
   }
}
