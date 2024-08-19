import SwiftUI

struct EmergencyContactsView: View {
    @StateObject private var viewModel = EmergencyContactsViewModel()
    @State private var hasContactAccess = false
    
    var body: some View {
        VStack {
            if hasContactAccess {
                if viewModel.selectedContacts.isEmpty {
                    Text("No emergency contacts available.")
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.selectedContacts) { contact in
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .font(.subheadline)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let contact = viewModel.selectedContacts[index]
                                viewModel.deleteContact(contact: contact)
                            }
                        }
                    }
                }
                
                Button("Select Emergency Contacts") {
                    viewModel.showContactPicker()
                }
                .padding()
            } else {
                Text("This app requires access to your contacts to allow you to select emergency contacts.")
                    .padding()
                
                Button("Allow Contacts Access") {
                    viewModel.requestContactAccess { granted in
                        hasContactAccess = granted
                        if granted {
                            viewModel.showContactPicker()
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.requestContactAccess { granted in
                hasContactAccess = granted
                if granted {
                    viewModel.fetchSavedContacts()
                }
            }
        }
    }
}

#Preview {
    EmergencyContactsView()
}
