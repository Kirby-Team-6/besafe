//
//  OnboardingView.swift
//  besafe
//
//  Created by Paulus Michael on 20/08/24.
//

import SwiftUI

struct OnboardingView: View {
   var body: some View {
      TabView {
         VStack {
            Spacer()
            
            Image(.iconBig)
               .resizable()
               .scaledToFill()
               .frame(width: 300, height: 300)
            
            Spacer()
            
            Text("Welcome to BeSafe")
               .font(.title)
               .fontWeight(.bold)
            
            
            Text("Get in the move to safety with Navigation that guides you to the nearest spot where help awaits.")
               .multilineTextAlignment(.center)
            
            Spacer()
         }
         .padding()
         
         VStack {
            Image(.iconBig)
               .resizable()
               .scaledToFill()
               .frame(width: 300, height: 300)
            
            Text("Welcome to BeSafe")
               .font(.title)
               .fontWeight(.bold)
            
            Text("Get in the move to safety with Navigation that guides you to the nearest spot where help awaits.")
               .multilineTextAlignment(.center)
         }
         .padding()
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
      .indexViewStyle(.page(backgroundDisplayMode: .always))
   }
}

#Preview {
   OnboardingView()
}
