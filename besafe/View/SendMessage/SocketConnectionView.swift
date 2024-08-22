//
//  SocketConnectionView.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 22/08/24.
//

import SwiftUI

struct SocketConnectionView: View {
    @State private var isConnected = false
    
    var body: some View {
        VStack {
            Text(isConnected ? "Connected to Socket" : "Not Connected")
                .foregroundColor(isConnected ? .green : .red)
                .padding()
            
            Button(action: {
                if isConnected {
                    // Optionally handle disconnection or other actions
                    print("Already connected")
                }
            }) {
                Text(isConnected ? "Connected" : "Connecting...")
                    .foregroundColor(.white)
                    .padding()
                    .background(isConnected ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(true) // Button is disabled because connection is handled in onAppear
            .padding()
        }
        .onAppear {
            if !isConnected {
                SocketHandler.shared.connect()
                isConnected = true
            }
        }
    }
}

#Preview {
    SocketConnectionView()
}
