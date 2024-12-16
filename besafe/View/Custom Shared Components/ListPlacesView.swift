//
//  ListPlacesView.swift
//  besafe
//
//  Created by Paulus Michael on 22/08/24.
//

import SwiftUI

struct ListPlacesView: View {
   var name: String
   var title: String
   
   var body: some View {
      HStack {
         MarkerIconView(color: .blue, img: "building.fill")
         VStack(alignment: .leading) {
            Text(name)
               .font(.headline)
            Text(title)
               .font(.subheadline)
               .foregroundColor(.gray)
         }
      }
   }
}
