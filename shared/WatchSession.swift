//
//  WatchSession.swift
//  besafe
//
//  Created by Paulus Michael on 21/08/24.
//

import Combine
import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate{
   let textSubject1: PassthroughSubject<String, Never>
   let textSubject2: PassthroughSubject<String, Never>
   
   init(textSubject1: PassthroughSubject<String, Never>, textSubject2: PassthroughSubject<String, Never>) {
      self.textSubject1 = textSubject1
      self.textSubject2 = textSubject2
      super.init()
   }
   
   func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
      // Protocol comformance only
      // Not needed for this demo
   }
   
   func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
      DispatchQueue.main.async {
         if let text1 = message["text1"] as? String {
            self.textSubject1.send(text1)
         } else {
            print("There was an error text1")
         }
         
         if let text2 = message["text2"] as? String {
            self.textSubject2.send(text2)
         } else {
            print("There was an error text2")
         }
      }
   }
   
   // iOS Protocol comformance
   // Not needed for this demo otherwise
#if os(iOS)
   func sessionDidBecomeInactive(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
   }
   
   func sessionDidDeactivate(_ session: WCSession) {
      // Activate the new session after having switched to a new watch.
      session.activate()
   }
   
   func sessionWatchStateDidChange(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
   }
#endif
}
