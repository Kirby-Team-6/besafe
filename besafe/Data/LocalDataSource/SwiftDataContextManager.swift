//
//  SwiftDataContextManager.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

//import Foundation
//import SwiftData
//
//public class SwiftDataContextManager {
//    public static var shared = SwiftDataContextManager()
//    var container: ModelContainer?
//    var context: ModelContext?
//
//    init() {
//        do {
//
////            container = try ModelContainer(for: NoteListLocalEntity.self)
////            if let container {
////                context = ModelContext(container)
////            }
//        } catch {
//            debugPrint("Error initializing database container:", error)
//        }
//    }
//}



import Foundation
import SwiftData
import CoreLocation

public class SwiftDataContextManager {
   private var container: ModelContainer
   private var context: ModelContext
   
   @MainActor
   public static let shared = SwiftDataContextManager()
   
   @MainActor
   init() {
      self.container = try! ModelContainer(for: [MapPoint.self,EmergencyContact.self], configurations: ModelConfiguration(isStoredInMemoryOnly: false))
      self.context = container.mainContext
   }

       func fetchEmergencyContacts() -> [EmergencyContact] {
        do {
            return try context.fetch(FetchDescriptor<EmergencyContact>())
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
      context.insert(point)
      do{
         try context.save()
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
