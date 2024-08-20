//
//  ModalityTitleView.swift
//  besafe
//
//  Created by Paulus Michael on 19/08/24.
//

import SwiftUI
import MapKit

struct ModalityTitleView: View {
   var cancelString: String
   var title: String
   var confirmString: String
   
   var cancelFunc: () -> Void
   var submitFunc: () -> Void
   
   var body: some View {
      HStack{
         Button("Cancel") {
            cancelFunc()
         }
         
         Spacer()
         
         Text("New Preferred Place")
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.headline)
         
         Spacer()
         
         Button(action: {
            submitFunc()
         }, label: {
            Text("Submit")
               .fontWeight(.semibold)
         })
      }
      .padding(.top, 8)
   }
}
