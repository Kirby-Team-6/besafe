//
//  ContentView.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
   @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
   var body: some View {
       ZStack{
           Map(position: $position){
              UserAnnotation()
           }
           VStack {
               HStack {
                   Image(systemName: "arrow.turn.up.left")
                       .font(.system(size: 28))
                   .padding(9)
                   .background(.blue)
                   .clipShape(.circle)
                   .offset(x: -4)
                   
                   
                   VStack(alignment: .leading){
                       Text("10 m")
                           .font(.system(size: 18))
                           .fontWeight(.semibold)
                       Text("On Dadap Barat")
                           .font(.system(size: 12))
                           .fontWeight(.medium)
                           .opacity(0.6)
                   }
                   .padding(.vertical, 5)
                   .offset(x: -4)

                   Spacer()
               }
               .frame(alignment: .leading)
               .background(.black.opacity(0.5))
               .cornerRadius(40)

               
               Spacer()
               
               HStack {
                   Spacer()
                   VStack(alignment: .center) {
                       Text("15")
                           .font(.system(size: 18))
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                       Text("min")
                           .font(.system(size: 12))
                           .fontWeight(.medium)
                           .foregroundColor(.gray)
                   }
                   Spacer()
                   VStack(alignment: .center) {
                       Text("300")
                           .font(.system(size: 18))
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                       Text("m")
                           .font(.system(size: 12))
                           .fontWeight(.medium)
                           .foregroundColor(.gray)
                   }
                   Spacer()
                   
                   
                   
                   Button(action: {
                       
                   }, label: {
                       Image(systemName: "xmark.circle.fill")
                           .symbolRenderingMode(.multicolor)
                           .font(.system(size: 40))
                           .foregroundStyle(.red, .white)
                   })
                   .buttonStyle(PlainButtonStyle())
                   
               }
               .frame(alignment: .leading)
               .background(.black.opacity(0.5))
               .cornerRadius(40)
               .padding(.bottom, 10)

           }
           .ignoresSafeArea(.container)
           .padding(.horizontal, 10)
           .padding(.top, 0.5)
       }
       .fullScreenCover(isPresented: .constant(false)){
           VStack {
               Text("You have arrived at\nthe safe place")
                   .fixedSize(horizontal: false, vertical: true)
                   .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                   .multilineTextAlignment(.center)
                   .font(.system(size: 18))
                   .fontWeight(.medium)
                   .padding(.bottom, 8)
                   
               Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                   Text("Reroute")
               })
               .tint(.white.opacity(0.2))
               .buttonStyle(BorderedProminentButtonStyle())

               .padding(.bottom, 4)
               Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                   Text("Done")
                       
                       
               })
               .tint(.blue)
               .buttonStyle(BorderedProminentButtonStyle())
               
            
           }
           .padding(.horizontal, 10)
           .toolbar(.hidden, for: .navigationBar)
       }
       .onAppear{
         CLLocationManager().requestWhenInUseAuthorization()
      }
   }
}

#Preview {
    ContentView()
}
