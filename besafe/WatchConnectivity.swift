//
//  WatchConnectivity.swift
//  besafe
//
//  Created by Paulus Michael on 20/08/24.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
   
    @Published var heartRate: Double = 0.0
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            print("Watch session is supported")

            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
           if session.isReachable {
              print("Activated")
           }else{
              print("Nah")
           }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message: \(message)")
        if let heartRate = message["heartRate"] as? Double {
            DispatchQueue.main.async {
                self.heartRate = heartRate
            }
        }
    }
}
