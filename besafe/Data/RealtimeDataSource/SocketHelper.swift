//
//  SocketManager.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 22/08/24.
//

import Foundation
import SocketIO
import CoreLocation

final class SocketHelper {
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private var sessionId: String
    
    init(sessionId: String) {
        self.sessionId = sessionId
        setupSocket()
    }
    
    private func setupSocket() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress, .forcePolling(true)])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Connected to server")
            self.socket.emit("createRoom", self.sessionId)  // Join or create a room using sessionId
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket error: \(data)")
        }
        print("Socket CONNECT....")
        socket.connect()
    }
    
    func sendLocationUpdate(latitude: Double, longitude: Double) {
        let data: [String: Any] = ["sessionId": sessionId, "latitude": latitude, "longitude": longitude]
        socket.emit("locationUpdate", data)
    }
    
    func disconnectSocket() {
        socket.disconnect()
    }
}
