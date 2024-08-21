import SwiftUI
import Contacts
import ContactsUI
import SwiftData

struct EmergencyContactsView: View {
    @StateObject private var viewModel = EmergencyContactsViewModel()
    @State var hasContactAccess = false
    @State var activeAlert: ActiveAlert? = nil
    @State var contactToDelete: EmergencyContact?
    @State var contactToAdd: EmergencyContact?

    enum ActiveAlert: Identifiable {
        case deleteConfirmation
        case contactAccess
        case addConfirmation

        var id: Int {
            hashValue
        }
    }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image(systemName: "light.beacon.max.fill")
                    .font(.system(size: 34))
                    .foregroundColor(.red)

                VStack(spacing: 10) {
                    Text("Emergency Contact")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Your live location will be sent to the contact\nbelow while you navigate to the safe place")
                        .font(.system(size: 17))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.bottom, -10)

            List {
                if viewModel.selectedContacts.isEmpty {
                    Text("Add your friend or family contact to keep\nthem stay updated to your live-location")
                        .padding(.vertical, 8)
                } else {
                    ForEach(viewModel.selectedContacts) { contact in
                        VStack(alignment: .leading) {
                            Text(contact.name)
                                .font(.headline)
                            Text(contact.phoneNumber)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            contactToDelete = viewModel.selectedContacts[index]
                            activeAlert = .deleteConfirmation
                        }
                    }
                }

                Button(action: {
                    if hasContactAccess {
                        viewModel.showContactPicker() // Tampilkan contact picker
                    } else {
                        activeAlert = .contactAccess
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 19))

                        Text("Add emergency contact")
                            .font(.system(size: 17))
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .onAppear {
            viewModel.requestContactAccess { granted in
                hasContactAccess = granted
                if granted {
                    viewModel.fetchSavedContacts()
                }
            }
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .deleteConfirmation:
                return Alert(
                    title: Text("Are you sure you want to delete this emergency contact?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let contact = contactToDelete {
                            viewModel.deleteContact(contact: contact)
                        }
                    },
                    secondaryButton: .cancel()
                )
            case .contactAccess:
                return Alert(
                    title: Text("Contact Access Denied"),
                    message: Text("Please allow contact access in Settings to add an emergency contact."),
                    primaryButton: .default(Text("Open Settings")) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    },
                    secondaryButton: .cancel()
                )
            case .addConfirmation:
                return Alert(
                    title: Text("Add to your emergency contacts?"),
                    primaryButton: .default(Text("Add")) {
                        if let contact = contactToAdd {
                            viewModel.addContact(contact: contact)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

