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
    @State private var searchText = String()
    
    var filteredReasons: [Reason] {
        if searchText.isEmpty {
            return vm.reasons
        } else {
            return vm.reasons.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            if vm.reasons.isEmpty {
                 HStack {
                     Spacer()
                     ProgressView("Carregando motivos…")
                     Spacer()
                 }
            } else {
                List {
                    ForEach(filteredReasons.filter { $0.status != .answered }) { reason in
                        NavigationLink(destination: ReasonDetailView(reason: reason, vm: vm)) {
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
                    Button(action: { showingAddReason.toggle() }) { Image(systemName: "plus.message") }
                    Button(action: { showingContacts.toggle() }) { Image(systemName: "person.fill.badge.plus") }
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
                .searchable(text: $searchText, prompt: "Buscar motivo de oração")
                .refreshable {
                    Task {
                        await vm.fetchReasons()
                    }
                }
            }
        } detail: {
            Text("Selecione um motivo de oração na lista para ver mais detalhes.")
        }
    }

    func delete(at indexSet: IndexSet) {
        let ids = indexSet.compactMap { filteredReasons.filter { $0.status != .answered }[$0].id }
        ids.forEach { id in
            Task {
                await vm.deleteReason(with: id)
            }
        }
    }
}

#Preview {
    ReasonListView(vm: ReasonViewModel())
}
