//
//  ContactSelectionView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 15/08/25.
//

import SwiftUI
import Contacts

struct ContactSelectionView: View {
    @ObservedObject var contactsVM: ContactsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText = String()

    var onAdd: ([CNContact]) -> Void

    var filteredContacts: [CNContact] {
        if searchText.isEmpty {
            return contactsVM.contacts
        } else {
            return contactsVM.contacts.filter { contact in
                let name = "\(contact.givenName) \(contact.familyName)"
                return name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if contactsVM.state == .authorized || contactsVM.state == .limited || contactsVM.state == .notDetermined {
                    List {
                        ForEach(filteredContacts, id: \.identifier) { contact in
                            Button(action: {
                                contactsVM.toggleSelection(for: contact)
                            }) {
                                HStack {
                                    Text("\(contact.givenName) \(contact.familyName)")
                                    Spacer()
                                    if contactsVM.selectedContacts.contains(contact.identifier) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        if contactsVM.state == .limited {
                            Section {
                                VStack(spacing: 12) {
                                    Text("Para ver mais contatos, abra os ajustes do app e permita acesso total aos seus contatos ou edite a lista atual.")
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.secondary)
                                    Button(action: {
                                        if let url = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Text("Abrir Ajustes")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .listSectionSpacing(16)
                    .navigationTitle("Selecionar Contatos")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Adicionar") {
                                let selected = contactsVM.contacts.filter {
                                    contactsVM.selectedContacts.contains($0.identifier)
                                }
                                onAdd(selected)
                                dismiss()
                            }
                            .disabled(contactsVM.selectedContacts.isEmpty)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancelar") { dismiss() }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Buscar contato")
                    .onAppear {
                        contactsVM.requestAccess()
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("O acesso aos contatos está desativado.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Abrir Ajustes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        }
    }
}
#Preview {
    ContactSelectionView(contactsVM: ContactsViewModel(), onAdd: {_ in })
}
