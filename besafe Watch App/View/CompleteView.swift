//
//  CompleteView.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 21/08/24.
//

import SwiftUI

struct CompleteView: View {
    var body: some View {
        VStack {
            Text("You have arrived at\nthe safe place")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding(.bottom, 8)
                
            Button(action: {
                
            }, label: {
                Text("Reroute")
            })
            .tint(.white.opacity(0.2))
            .buttonStyle(BorderedProminentButtonStyle())

            .padding(.bottom, 4)
            Button(action: {
                
            }, label: {
                Text("Done")
            })
            .tint(.blue)
            .buttonStyle(BorderedProminentButtonStyle())
            
         
        }
        .padding(.horizontal, 10)
        .toolbar(.hidden, for: .navigationBar)

    }
}

#Preview {
    CompleteView()
}
