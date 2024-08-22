//
//  WatchConnect.swift
//  besafe
//
//  Created by Paulus Michael on 21/08/24.
//

import Combine
import SwiftUI
import WatchConnectivity
import CoreLocation

class WatchConnect: NSObject, WCSessionDelegate, ObservableObject {
   var session: WCSession
   
   @StateObject var mapPointViewModel = MapPointViewModel(dataSource: .shared)
   
   static let shared = WatchConnect()
    
    #if os(watchOS)
    @Published var routeModel : RouteModel?
    #endif
   
   init(session: WCSession = .default) {
      self.session = session
      super.init()
      
      self.session.delegate = self
      self.session.activate()
   }
   
   func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
      // Protocol comformance only
      // Not needed for this demo
   }
 
#if os(iOS)
   func sessionDidBecomeInactive(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
   }
   
   func sessionDidDeactivate(_ session: WCSession) {
      session.activate()
   }
   
   func sessionWatchStateDidChange(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
   }
   
   func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
       if let actionId = message["actionId"] as? Int{
           print("Action Id: \(actionId)")
           if actionId == 0 {
               let latitude = message["userLatitude"] as! Double
               let longitude = message["userLongitude"] as! Double
               let destinationLat = message["destinationLatitude"] as! Double
               let destinationLong = message["destinationLongitude"] as! Double
               SafePlaceUtils.directionAppleWatch(
                from: CLLocation(latitude: latitude, longitude: longitude),
                to: CLLocation(latitude: destinationLat, longitude: destinationLong)){ route in
                   session.sendMessage(["route": route.encodeToJSONString()!], replyHandler: nil)
               }
           }
       } else{
         print("iOS not received any data")
       }
   }
#else
   func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
       if let route = message["route"] as? String {
           let data = RouteModel.decodeFromJSONString(jsonString: route)
           DispatchQueue.main.async {
               self.routeModel = data
           }
       } else {
          print("Route is empty")
       }
   }
#endif
}


