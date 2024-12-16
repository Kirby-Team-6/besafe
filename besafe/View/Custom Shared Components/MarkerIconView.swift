//
//  MarkerIconView.swift
//  besafe
//
//  Created by Paulus Michael on 20/08/24.
//

import SwiftUI

struct MarkerIconView: View {
   var color: Color
   var img: String
   
   var body: some View {
      ZStack {
         Circle()
            .fill(color)
            .frame(width: 45, height: 45) // Adjust the size as needed
         
         Image(systemName: img)
            .foregroundStyle(.white)
            .font(.title3) // Adjust the icon size as needed
      }
   }
}
