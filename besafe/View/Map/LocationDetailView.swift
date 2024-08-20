//
//  LocationDetailView.swift
//  besafe
//
//  Created by Paulus Michael on 19/08/24.
//

import SwiftUI

struct LocationDetailView: View {
   @Binding var name: String
   @Environment(\.dismiss) var dismiss
   @EnvironmentObject var pointViewModel: MapPointViewModel
   var mapPoint: MapPoint
   
   let columns = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible())
   ]
   
   var body: some View {
      VStack {
         ModalityTitleView(cancelString: "Delete", title: "Custom Place", confirmString: "Submit", cancelFunc: {
            pointViewModel.delete(point: mapPoint)
            dismiss()
         }, submitFunc: {
            pointViewModel.update(point: mapPoint, name: name, lat: mapPoint.latitude, long: mapPoint.longitude)
            dismiss()
         })
         
         HStack {
            ZStack {
               Circle()
                  .frame(width: 35, height: 35)
                  .foregroundStyle(.red)
               Image(systemName: "heart.fill")
                  .font(.headline)
                  .foregroundStyle(.white)
            }
            TextField("Marker name", text: $name)
         }
         .padding(12)
         .background(.customWhite)
         .clipShape(RoundedRectangle(cornerRadius: 12))
         
         Spacer()
      }
      .padding()
      .background(.neutral)
   }
}
