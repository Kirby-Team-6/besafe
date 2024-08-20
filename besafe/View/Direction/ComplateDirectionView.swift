//
//  ComplateDirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import SwiftUI

struct ComplateDirectionView: View {
    var body: some View {
        VStack {
            Text("You have arrived at\nthe safe place")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.bottom, 24)
                
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Reroute")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
            })
            .tint(.greyC6)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 10)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Done")
                    .fontWeight(.semibold)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
            })
            .tint(.blue)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(.horizontal, 10)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ComplateDirectionView()
}
