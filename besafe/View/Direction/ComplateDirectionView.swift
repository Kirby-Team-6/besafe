//
//  ComplateDirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import SwiftUI

struct ComplateDirectionView: View {
    let onReroute: () -> Void
    let onDone: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("You have arrived at\nthe safe place")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.regular)
                .padding(.bottom, 24)
                
            Button(action: {
                onDone()
            }, label: {
                Text("Done")
                    .fontWeight(.semibold)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
            })
            .tint(.blue)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            Spacer()
            Button(action: {
                onReroute()
            }, label: {
                Text("Reroute")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: UIScreen.main.bounds.width / 3)
            })
            .tint(.white)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 10)

            Text("If there’s no one there, you can reroute\nto another safe place")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.6))
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .fontWeight(.regular)
                .padding(.bottom, 24)

            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ComplateDirectionView(onReroute: {}) {
        
    }
}
