//
//  MapPointViewModel.swift
//  besafe
//
//  Created by Paulus Michael on 18/08/24.
//

import Foundation
import SwiftData

class MapPointViewModel: ObservableObject {
   @Published var mapPoint: [MapPoint] = []
   
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
}
