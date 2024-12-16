import Foundation
import SwiftData

@Model
class EmergencyContact: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String

    init(id: UUID = UUID(), name: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
