//
//  TextfieldWithMarkerView.swift
//  besafe
//
//  Created by Paulus Michael on 20/08/24.
//

import SwiftUI

struct TextfieldWithMarkerView: View {
   var color: Color
   var img: String
   @Binding var textfieldString: String
   
   var body: some View {
      HStack {
         MarkerIconView(color: color, img: img)
         TextField("Marker name", text: $textfieldString)
      }
      .padding(12)
      .background(.customWhite)
      .clipShape(RoundedRectangle(cornerRadius: 12))
   }
}
