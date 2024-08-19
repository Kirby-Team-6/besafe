//
//  SocketManager.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 19/08/24.
//

import Foundation

class SocketManager: SocketManagerProtocol {
    private let url: URL
    private var task: URLSessionWebSocketTask?
    
    init(url: URL) {
        self.url = url
    }
    
    func connect() {
        task = URLSession.shared.webSocketTask(with: url)
        task?.resume()
        receiveMessage { result in
            switch result {
            case .success(let message):
                print("Received message: \(message)")
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
    }
    
    func sendLocation(latitude: Double, longitude: Double) {
        let locationData = ["latitude": latitude, "longitude": longitude]
        if let jsonData = try? JSONSerialization.data(withJSONObject: locationData, options: []) {
            let message = URLSessionWebSocketTask.Message.data(jsonData)
            task?.send(message) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                }
            }
        }
    }
    
    func receiveMessage(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        task?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let messageData = try? JSONSerialization.jsonObject(with: data, options: []),
                       let messageDict = messageData as? [String: Any] {
                        completion(.success(messageDict))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                    }
                case .string(let text):
                    print("Received text: \(text)")
                @unknown default:
                    break
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.receiveMessage(completion: completion)
        }
    }
    
    func disconnect() {
        task?.cancel(with: .normalClosure, reason: nil)
    }
}
