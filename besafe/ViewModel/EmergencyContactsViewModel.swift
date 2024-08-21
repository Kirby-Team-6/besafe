import SwiftUI
import Contacts
import ContactsUI
import SwiftData

// ViewModel tidak perlu tahu soal contactToAdd dan activeAlert
class EmergencyContactsViewModel: NSObject, ObservableObject, CNContactPickerDelegate {
    @Published var selectedContacts: [EmergencyContact] = []
    private let contactStore = CNContactStore()
    private let dataService = SwiftDataService.shared

    func requestContactAccess(completion: @escaping (Bool) -> Void) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func showContactPicker() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        picker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]

        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(picker, animated: true)
        }
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        for contact in contacts {
            let fullName = "\(contact.givenName) \(contact.familyName)"
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                let newContact = EmergencyContact(name: fullName, phoneNumber: phoneNumber)

                // Simpan kontak ke variabel sementara di View
                (picker.presentingViewController as? EmergencyContactsView)?.contactToAdd = newContact
                (picker.presentingViewController as? EmergencyContactsView)?.activeAlert = .addConfirmation
            }
        }
    }

    func fetchSavedContacts() {
        selectedContacts = dataService.fetchEmergencyContacts()
    }

    func deleteContact(contact: EmergencyContact) {
        dataService.deleteEmergencyContact(contact: contact)
        selectedContacts.removeAll { $0.id == contact.id }
    }

    func addContact(contact: EmergencyContact) {
        dataService.addEmergencyContact(contact: contact)
        selectedContacts.append(contact)
    }
}
