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
   @EnvironmentObject var watchConnect: WatchConnect
   
   var mapPoint: MapPoint
   
   @State var selectedIconID: UUID?
   @State var imgName: String?
   @State var color: Color?
   @State var indexStored: Int?
   
   let columns = [
      GridItem(.flexible()),
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
            //TODO: Updateny belom optimal
            pointViewModel.update(point: mapPoint, name: name, lat: mapPoint.latitude, long: mapPoint.longitude, index: mapPoint.markerIndex)
            
//            watchConnect.ubah(mapPoint.name, String(mapPoint.latitude))
            
            dismiss()
         })
         
         let icon = Variables.icons[mapPoint.markerIndex]
         
         TextfieldWithMarkerView(color: icon.color, img: icon.img, textfieldString: $name)

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
      .padding()
      .background(.neutral)
      .onAppear(perform: {
         selectedIconID = Variables.icons[mapPoint.markerIndex].id
         imgName = Variables.icons[mapPoint.markerIndex].img
         color = Variables.icons[mapPoint.markerIndex].color
      })
   }
}
