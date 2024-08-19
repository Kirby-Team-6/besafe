//
//  SocketManager.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 19/08/24.
//

import Foundation

// Define a protocol to adhere to the Dependency Inversion principle (D in SOLID)
protocol SocketManagerProtocol {
    func connect()
    func sendLocation(latitude: Double, longitude: Double)
    func receiveMessage(completion: @escaping (Result<[String: Any], Error>) -> Void)
    func disconnect()
}
