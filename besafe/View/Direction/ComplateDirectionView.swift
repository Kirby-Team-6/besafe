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
                .font(.title)
                .padding(.bottom, 24)
                
            Button(action: {
                onReroute()
            }, label: {
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
