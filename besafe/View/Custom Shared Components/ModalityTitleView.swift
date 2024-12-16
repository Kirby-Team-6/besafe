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
         Button(cancelString) {
            cancelFunc()
         }
         
         Spacer()
         
         Text(title)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.headline)
         
         Spacer()
         
         Button(action: {
            submitFunc()
         }, label: {
            Text(confirmString)
               .fontWeight(.semibold)
         })
      }
      .padding(.top, 8)
   }
}
