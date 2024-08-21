//
//  SwiftDataContextManager.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation
import SwiftData

class SwiftDataService {
   private let container: ModelContainer
    let context: ModelContext
   
   @MainActor
   static let shared = SwiftDataService()
   
   @MainActor
   init() {
       self.container = try! ModelContainer(for: EmergencyContact.self, MapPoint.self, ExcludePlaceModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
      self.context = container.mainContext
   }
   
   func fetchEmergencyContacts() -> [EmergencyContact] {
      do {
         return try context.fetch(FetchDescriptor<EmergencyContact>())
      } catch {
         fatalError(error.localizedDescription)
      }
   }
    
    func addExcludePlace(_ place: ExcludePlaceModel) {
        context.insert(place)
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getExcludePlaces() -> [ExcludePlaceModel] {
        do {
            return try context.fetch(FetchDescriptor<ExcludePlaceModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

   
   func addEmergencyContact(contact: EmergencyContact) {
      context.insert(contact)
      do {
         try context.save()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   func deleteEmergencyContact(contact: EmergencyContact) {
      context.delete(contact)
      do {
         try context.save()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   func fetchMapPoints() -> [MapPoint]{
      do{
         return try context.fetch(FetchDescriptor<MapPoint>())
      }catch{
         fatalError(error.localizedDescription)
      }
   }
   
   func addMapPoint(point: MapPoint){
         self.context.insert(point)
         do{
            try self.context.save()
         }catch{
            fatalError(error.localizedDescription)
         }
      
   }
   
   func updateMapPoint(point: MapPoint, name: String, lat: Double, long: Double){
      do{
         point.name = name
         point.latitude = lat
         point.longitude = long
         
         try context.save()
      }catch{
         fatalError(error.localizedDescription)
      }
   }
   
   func deleteMapPoint(point: MapPoint){
      context.delete(point)
      do{
         try context.save()
      }catch{
         fatalError(error.localizedDescription)
      }
   }
}
