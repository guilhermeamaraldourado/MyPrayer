//
//  ContactsViewModel.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 15/08/25.
//

import Contacts
import SwiftUI

enum ContactAccessState {
    case notDetermined
    case denied
    case authorized
    case limited
}

class ContactsViewModel: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var selectedContacts: Set<String> = []
    @Published var state: ContactAccessState = .notDetermined
    
    private let store = CNContactStore()
    
    func checkAuthorization() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            state = .notDetermined
        case .denied, .restricted:
            state = .denied
        case .authorized:
            state = .authorized
        case .limited:
            state = .limited
        @unknown default:
            state = .denied
        }
    }
    
    func requestAccess() {
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.checkAuthorization()
                self.fetchContacts()
            } else {
                print("Acesso negado aos contatos")
            }
        }
    }
    
    func fetchContacts() {
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keys)

        DispatchQueue.global(qos: .userInitiated).async {
            var tempContacts: [CNContact] = []
            do {
                try self.store.enumerateContacts(with: request) { contact, _ in
                    tempContacts.append(contact)
                }
                DispatchQueue.main.async {
                    self.contacts = tempContacts.sorted { $0.givenName < $1.givenName }
                }
            } catch {
                print("Erro ao buscar contatos: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleSelection(for contact: CNContact) {
        if selectedContacts.contains(contact.identifier) {
            selectedContacts.remove(contact.identifier)
        } else {
            selectedContacts.insert(contact.identifier)
        }
    }
}
