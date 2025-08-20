//
//  ReasonListView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct ReasonListView: View {
    @ObservedObject var vm: ReasonViewModel
    @StateObject private var contactsVM = ContactsViewModel()
    @State private var showingAddReason = false
    @State private var showingContacts = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.reasons.filter { $0.status != .answered }) { reason in
                    NavigationLink(destination: ReasonDetailView(
                        reason: reason,
                        vm: vm
                    )) {
                        VStack(alignment: .leading) {
                            Text(reason.title).font(.headline)
                            Text(reason.type.rawValue).font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Meus motivos")
            .toolbar {
                Button(action: { showingAddReason.toggle() }) {
                    Image(systemName: "plus.message")
                }
                Button(action: { showingContacts.toggle() }) {
                    Image(systemName: "person.fill.badge.plus")
                }
            }
            .sheet(isPresented: $showingAddReason) {
                AddReasonView(vm: vm)
            }
            .sheet(isPresented: $showingContacts) {
                ContactSelectionView(contactsVM: contactsVM) { selectedContacts in
                    Task {
                        for contact in selectedContacts {
                            await vm.addReason(
                                title: "\(contact.givenName) \(contact.familyName)",
                                type: .request,
                                frequency: .daily
                            )
                        }
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        Task {
            await vm.deleteReasonAt(index: index)
        }
    }
}

#Preview {
    ReasonListView(vm: ReasonViewModel())
}
