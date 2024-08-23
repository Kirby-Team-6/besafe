//
//  ComplateDirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import SwiftUI

struct ComplateDirectionView: View {
    @Environment(\.colorScheme) var colorScheme
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
            .tint(.primaryDarkBlue)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Spacer()
            
            Text("Cannot find anyone for help?")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .fontWeight(.regular)
                .padding(.bottom, 14)
            
            Button(action: {
                onReroute()
            }, label: {
                Text("Reroute")
                    .foregroundColor(.primary)
                    .frame(maxWidth: UIScreen.main.bounds.width / 5)
            })
            .tint(.white.opacity(colorScheme == .dark ? 0.3 : 0.9))
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 50)

            
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
