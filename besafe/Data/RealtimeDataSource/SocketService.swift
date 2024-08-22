//
//  SocketServiceProtocol.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 20/08/24.
//

import Foundation
import SocketIO

protocol SocketService {
    func establishConnection(withSessionId sessionId: String)
    func sendLocationUpdate(sessionId: String, latitude: Double, longitude: Double)
    func disconnect()
}

class SocketIOManager: SocketService {
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    init(baseURL: String) {
        let socketUrl = URL(string: baseURL)!
        manager = SocketManager(socketURL: socketUrl, config: [.log(true), .compress])
        socket = manager.defaultSocket
        print("SocketManager initialized")
    }
    
    func establishConnection(withSessionId sessionId: String) {
        print("Attempting to establish connection with session ID: \(sessionId)")
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket connected with session ID: \(sessionId)")
            self?.registerSession(sessionId: sessionId)
        }
        socket.connect()
    }
    
    private func registerSession(sessionId: String) {
        socket.emit("registerSession", ["sessionId": sessionId])
    }
    
    func sendLocationUpdate(sessionId: String, latitude: Double, longitude: Double) {
        socket.emit("locationUpdate", ["sessionId": sessionId, "latitude": latitude, "longitude": longitude])
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
