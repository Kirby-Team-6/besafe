//
//  WatchTestView.swift
//  besafe
//
//  Created by Paulus Michael on 21/08/24.
//

import SwiftUI

struct WatchTestView: View {
   @StateObject var connect = WatchConnect()
   
   var body: some View {
      VStack{
         Text(connect.text1)
         Text(connect.text2)
         
         Button(action: {
            connect.increment()
         }, label: {
            Text("Send Message 1")
         })
         
         Button(action: {
            connect.decrement()
         }, label: {
            Text("Send Message 2")
         })
         .onChange(of: connect.text1) { oldValue, newValue in
            print(oldValue)
            print(newValue)
            connect.ubah()
         }
      }
   }
}

#Preview {
   WatchTestView()
}
