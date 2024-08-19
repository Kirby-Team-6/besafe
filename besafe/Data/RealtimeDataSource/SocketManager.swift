//
//  SocketManager.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 19/08/24.
//

import Foundation

class SocketManager: SocketManagerProtocol {
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var sessionId: String
    
    init(url: URL) {
        self.url = url
        self.sessionId = generateSessionID()
    }
    
    func connect() {
        var request = URLRequest(url: url)
        request.addValue(sessionId, forHTTPHeaderField: "Session-ID")
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
    }
    
    func sendLocation(latitude: Double, longitude: Double) {
        let locationData: [String: Any] = ["sessionId": sessionId, "latitude": latitude, "longitude": longitude]
        if let jsonData = try? JSONSerialization.data(withJSONObject: locationData, options: []) {
            let message = URLSessionWebSocketTask.Message.data(jsonData)
            webSocketTask?.send(message) { error in
                if let error = error {
                    print("Error sending location: \(error)")
                }
            }
        }
    }
    
    func receiveMessage(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let jsonDict = json as? [String: Any] {
                        completion(.success(jsonDict))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                    }
                default:
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported message type"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
}
