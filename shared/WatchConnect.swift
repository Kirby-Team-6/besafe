//
//  WatchConnect.swift
//  besafe
//
//  Created by Paulus Michael on 21/08/24.
//

import Combine
import SwiftUI
import WatchConnectivity

class WatchConnect: NSObject, WCSessionDelegate, ObservableObject {
   var session: WCSession
   let subject1 = PassthroughSubject<String, Never>()
   let subject2 = PassthroughSubject<Double, Never>()
   let subject3 = PassthroughSubject<Double, Never>()
   
   @StateObject var mapPointViewModel = MapPointViewModel(dataSource: .shared)
   
   static let shared = WatchConnect()
   
   @Published private(set) var placeName: String = ""
   @Published private(set) var latitude: Double = 0
   @Published private(set) var longitude: Double = 0
   
   init(session: WCSession = .default) {
      self.session = session
      super.init()
      
      self.session.delegate = self
      self.session.activate()
      
      subject1
         .receive(on: DispatchQueue.main)
         .assign(to: &$placeName)
      
      subject2
         .receive(on: DispatchQueue.main)
         .assign(to: &$longitude)
      
      subject3
         .receive(on: DispatchQueue.main)
         .assign(to: &$latitude)
   }
   
   func setName(name: String){
      placeName = name
   }
   
   func setLong(long: Double){
      longitude = long
   }
   
   func setLat(lat: Double){
      latitude = lat
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
#else
   func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
      if let name = message["placeNameAfter"] as? String {
         self.subject1.send(name)
         self.setName(name: name)// Update the published variable
         print(name)
      } else {
         self.setName(name: "Place Not Found") // Set to a default value or handle error
         print("There was an error (name)")
      }
      
      if let longitude = message["longitudeAfter"] as? Double {
         self.subject2.send(longitude)
         self.setLong(long: longitude)// Update the published variable
         print(longitude)
      } else {
         self.setName(name: "Place Not Found") // Set to a default value or handle error
         print("There was an error (longitude)")
      }
      
      if let latitude = message["latitudeAfter"] as? Double {
         self.subject3.send(latitude)
         self.setLat(lat: latitude)// Update the published variable
         print(latitude)
      } else {
         self.setName(name: "Place Not Found") // Set to a default value or handle error
         print("There was an error (latitude)")
      }
   }
#endif
}


