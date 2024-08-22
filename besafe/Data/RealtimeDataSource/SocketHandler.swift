//
//  SocketHandler.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 22/08/24.
//

import Foundation
import SocketIO

class SocketHandler {

    static let shared = SocketHandler()
    var socket: SocketIOClient?
    private var manager: SocketManager?
    var sessionId: String

    private init() {
        // Generate a session ID (UUID)
        sessionId = generateSessionID()
        
        // Initialize the Socket.IO client
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socket = manager?.defaultSocket

        // Register session ID with the server
        socket?.on(clientEvent: .connect) { data, ack in
            self.socket?.emit("registerSession", ["sessionId": self.sessionId])
            print("Connected with session ID: \(self.sessionId)")
        }

        // Handle location updates from the server (if needed)
        socket?.on("locationUpdate") { dataArray, ack in
            guard let data = dataArray[0] as? [String: Any],
                  let latitude = data["latitude"] as? Double,
                  let longitude = data["longitude"] as? Double else { return }
            // Handle received location update
            print("Received location update: \(latitude), \(longitude)")
        }
    }

    func connect() {
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    func sendLocationUpdate(latitude: Double, longitude: Double) {
        socket?.emit("locationUpdate", ["sessionId": sessionId, "latitude": latitude, "longitude": longitude])
    }
}
