//
//  MapPointViewModel.swift
//  besafe
//
//  Created by Paulus Michael on 18/08/24.
//

import Foundation
import SwiftUI
import SwiftData
import WatchConnectivity

class MapPointViewModel: ObservableObject {
   @Published var mapPoint: [MapPoint] = []
   @StateObject var watchConnect = WatchConnect.shared
   
   private let dataSource: SwiftDataService
   
   init(dataSource: SwiftDataService) {
      self.dataSource = dataSource
      
      self.mapPoint = dataSource.fetchMapPoints()
      
   }
   
   func add(point: MapPoint){
      dataSource.addMapPoint(point: point)
      
      self.mapPoint = self.dataSource.fetchMapPoints()
      
   }
   
   func delete(point: MapPoint){
      dataSource.deleteMapPoint(point: point)
      DispatchQueue.main.async{
         self.mapPoint = self.dataSource.fetchMapPoints()
      }
   }
   
   func update(point: MapPoint, name: String, lat: Double, long: Double, index: Int){
      dataSource.updateMapPoint(point: point, name: name, lat: lat, long: long, index: index)
      
      self.mapPoint = self.dataSource.fetchMapPoints()
   }
   
   func getOnePoint(){
      if let thatOnePlace = mapPoint.first {
         let name = thatOnePlace.name
         let longitude = thatOnePlace.longitude
         let latitude = thatOnePlace.latitude
         
         watchConnect.session.sendMessage(["placeNameAfter": name, "longitudeAfter": longitude, "latitudeAfter": latitude], replyHandler: nil){ error in
            print(error.localizedDescription)
         }
//         watchConnect.setName(name: name)
//         watchConnect.setLong(long: longitude)
//         watchConnect.setLat(lat: latitude)
//         watchConnect.getCustomSafePlace(name: name, longitude: longitude, latitude: latitude)
      }else{
         print("No data")
      }
   }
}
