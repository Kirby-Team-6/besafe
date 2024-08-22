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
   @StateObject var safePlaceVM = SafePlacesViewModel()
   
   var reader: MapProxy
   
   @FocusState private var isFocused: Bool
   
   var body: some View {
      GeometryReader { geometry in
         VStack {
            if addingPoint {
               VStack {
                  CustomLocationNameView(searchText: $searchText, onTapAdd: $onTapAdd, addingPoint: $addingPoint, reader: reader)
                     .focused($isFocused)
                     .onChange(of: isFocused) { oldValue, newValue in
                        withAnimation {
                           overlayHeight = newValue ? geometry.size.height * 0.5 : UIScreen.main.bounds.height * 0.3
                        }
                     }
               }
               .frame(maxWidth: .infinity)
               .frame(height: overlayHeight)
               .offset(y: geometry.size.height - overlayHeight)
               .gesture(
                  DragGesture()
                     .onChanged { value in
                        withAnimation{
                           safePlaceVM.calculateSafePlaceHeight(valueHeight: value.translation.height, height: geometry.size.height, overlayHeight: &overlayHeight)
                        }
                     }
               )
               .transition(.move(edge: .bottom))
            } else {
               VStack {
                  SearchPlaceView(addingPoint: $addingPoint)
                     .focused($isFocused)
                     .onChange(of: isFocused) { oldValue, newValue in
                        withAnimation {
                           overlayHeight = newValue ? geometry.size.height * 0.5 : geometry.size.height * 0.3
                        }
                     }
               }
               .frame(maxWidth: .infinity)
               .frame(height: overlayHeight)
               .offset(y: geometry.size.height - overlayHeight)
               .gesture(
                  DragGesture()
                     .onChanged { value in
                        withAnimation{
                           safePlaceVM.calculateSafePlaceHeight(valueHeight: value.translation.height, height: geometry.size.height, overlayHeight: &overlayHeight)
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
