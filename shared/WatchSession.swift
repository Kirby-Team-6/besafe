//
//  WatchSession.swift
//  besafe
//
//  Created by Paulus Michael on 21/08/24.
//

import Combine
import WatchConnectivity
import SwiftUI

class WatchSession: NSObject, WCSessionDelegate{
   let nameSubject: PassthroughSubject<String, Never>
   let longSubject: PassthroughSubject<Double, Never>
   let latSubject: PassthroughSubject<Double, Never>
   
   weak var watchConnect: WatchConnect?
   
   @StateObject var mapPointViewModel = MapPointViewModel(dataSource: .shared)
   
   init(nameSubject: PassthroughSubject<String, Never>, longSubject: PassthroughSubject<Double, Never>, latSubject: PassthroughSubject<Double, Never>) {
      self.nameSubject = nameSubject
      self.longSubject = longSubject
      self.latSubject = latSubject
      super.init()
   }
   
   func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
      // Protocol comformance only
      // Not needed for this demo
   }
   //
   //   func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
   //      DispatchQueue.main.async {
   //         if let name = message["name"] as? String {
   //            self.nameSubject.send(name)
   //            print(name)
   //         } else {
   //            print("There was an error (name)")
   //         }
   //
   //         if let long = message["long"] as? Double {
   //            self.longSubject.send(long)
   //            print(long)
   //         } else {
   //            print("There was an error (longitude)")
   //         }
   //
   //         if let lat = message["lat"] as? Double {
   //            self.latSubject.send(lat)
   //            print(lat)
   //         } else {
   //            print("There was an error (latitude)")
   //         }
   //      }
   //   }
   
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
   
   func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
      //      print("Place Name: \(message["name"] ?? "") (iOS)")
      //      print("Place Name: \(message["lat"] ?? "") (iOS)")
      //      print("Place Name: \(message["long"] ?? "") (iOS)")
      DispatchQueue.main.async{
         self.mapPointViewModel.getOnePoint()
      }
   }
#elseif os(watchOS)
   func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
      if let name = message["placeNameAfter"] as? String {
         self.nameSubject.send(name)
         self.watchConnect?.setName(name: name)// Update the published variable
         print(name)
      } else {
         self.watchConnect?.setName(name: "Place Not Found") // Set to a default value or handle error
         print("There was an error (name)")
      }
   }
#endif
}
