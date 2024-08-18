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

class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = SwiftDataService()

    @MainActor
    init() {
        self.modelContainer = try! ModelContainer(for: EmergencyContact.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext
    }

    func fetchEmergencyContacts() -> [EmergencyContact] {
        do {
            return try modelContext.fetch(FetchDescriptor<EmergencyContact>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func addEmergencyContact(contact: EmergencyContact) {
        modelContext.insert(contact)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func deleteEmergencyContact(contact: EmergencyContact) {
        modelContext.delete(contact)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
