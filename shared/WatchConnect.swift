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
    @Published var placeModel : [PlaceModel] = []
    @Published var statusMessage: String?
    #endif
    
//#if os(iOS)
//    private var swiftDataSource: SwiftDataService? = nil
//    func initialize(swiftDataSource: SwiftDataService)  {
//        self.swiftDataSource = swiftDataSource
//    }
//#endif
    
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
    
    func encodePlaceModelsToJsonString(placeModels: [PlaceModel]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(placeModels)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Failed to encode [PlaceModel]: \(error)")
            return nil
        }
    }
    
    func decodeJsonStringToPlaceModels(jsonString: String) -> [PlaceModel]? {
        let decoder = JSONDecoder()
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to create Data from JSON string")
            return nil
        }
        do {
            let placeModels = try decoder.decode([PlaceModel].self, from: jsonData)
            return placeModels
        } catch {
            print("Failed to decode JSON string: \(error)")
            return nil
        }
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
           } else if actionId == 1 {
               Task {
                   let data = SwiftDataService.shared.fetchMapPoints()
                   if data.isEmpty {
                       session.sendMessage(["message": "local data is empty"], replyHandler: nil)
                       return
                   }
                   let placaModel = data.map{
                       return PlaceModel(
                           id: UUID().uuidString,
                           location: Location(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                           currentOpeningHours: CurrentOpeningHours(openNow: true),
                           primaryType: "custom",
                           displayName: DisplayName(text: $0.name, languageCode: nil),
                           shortFormattedAddress: nil
                       )
                   }
                   if let jsonString = encodePlaceModelsToJsonString(placeModels: placaModel) {
                       session.sendMessage(["localData": jsonString], replyHandler: nil)
                   } else {
                       session.sendMessage(["message": "failed"], replyHandler: nil)
                   }
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
       }
       
       if let localData = message["localData"] as? String {
           self.statusMessage = "get local data"
           if let decodedPlaces = decodeJsonStringToPlaceModels(jsonString: localData) {
               self.placeModel = decodedPlaces
           } else {
               self.statusMessage = ("failed decode \(localData)")
           }
       }else {
           self.statusMessage = "not get local data"
       }
       
       if let messageStatus = message["message"] as? String {
           self.statusMessage = messageStatus
       }
   }
#endif
}


