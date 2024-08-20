//
//  MapOverlayView.swift
//  besafe
//
//  Created by Paulus Michael on 20/08/24.
//

import SwiftUI
import MapKit

struct MapOverlayView: View {
   @Binding var addingPoint: Bool
   @Binding var onTapAdd: Bool
   @Binding var searchText: String
   @Binding var customSafePlaceHeight: CGFloat
   @Binding var overlayHeight: CGFloat
   
   var reader: MapProxy
   
   var body: some View {
      GeometryReader { geometry in
         VStack {
            if addingPoint {
               VStack {
                  CustomLocationNameView(searchText: $searchText, onTapAdd: $onTapAdd, addingPoint: $addingPoint, reader: reader)
               }
               .frame(maxWidth: .infinity)
               .frame(height: customSafePlaceHeight)
               .offset(y: geometry.size.height - customSafePlaceHeight)
               .transition(.move(edge: .bottom))
            } else {
               VStack {
                  SearchPlaceView(addingPoint: $addingPoint)
               }
               .frame(maxWidth: .infinity)
               .frame(height: overlayHeight)
               .offset(y: geometry.size.height - overlayHeight)
               .gesture(
                  DragGesture()
                     .onChanged { value in
                        if value.translation.height < 0 {
                           let newHeight = min(geometry.size.height, geometry.size.height * 0.6)
                           withAnimation {
                              overlayHeight = newHeight
                           }
                        } else {
                           withAnimation {
                              overlayHeight = UIScreen.main.bounds.height * 0.3
                           }
                        }
                     }
               )
               .transition(.move(edge: .bottom))
            }
         }
      }
      .ignoresSafeArea()
   }
}
