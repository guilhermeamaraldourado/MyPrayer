//
//  AddReasonView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import Contacts
import SwiftUI

struct AddReasonView: View {
    @ObservedObject var vm: ReasonViewModel
    @StateObject private var contactsVM = ContactsViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showContacts = false
    @State private var title = ""
    @State private var type: ReasonType = .request
    @State private var frequency: Frequency = .one
    @State private var period: Period = .week
    @State private var hasDeadline: Bool = false
    @State private var deadline: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Título", text: $title)
                
                Picker("Tipo", selection: $type) {
                    ForEach(ReasonType.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.menu)
                
                Section(header: Text("Frequência")) {
                    HStack {
                        Picker("", selection: $frequency) {
                            ForEach(Frequency.allCases) { q in
                                Text(q.rawValue)
                                    .tag(q)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -32))
                        .disabled(period == .daily)
                        
                        Text(period == .daily ? "todo dia" : "por")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Picker("", selection: $period) {
                            ForEach(Period.allCases) { p in
                                Text(p.rawValue).tag(p)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .onChange(of: period) { newValue, _ in
                            if newValue == .daily {
                                frequency = .one
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 4, leading: -12, bottom: 4, trailing: 0))
                }
                
                Section(header: Text("Prazo")) {
                    Toggle("Esse motivo de oração tem data para terminar?", isOn: $hasDeadline.animation())
                    
                    if hasDeadline {
                        DatePicker(
                            "Selecione a data",
                            selection: $deadline,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                    }
                }
                Section(header: Text("Contatos")) {
                    Text("Se preferir, adicione um ou mais contatos como motivos de oração")
                    Button(action: {
                        showContacts.toggle()
                    }) {
                        Text("Adicionar")
                    }
                }
            }
            .sheet(isPresented: $showContacts) {
                ContactSelectionView(contactsVM: contactsVM) { selectedContacts in
                    Task {
                        for contact in selectedContacts {
                            await vm.addReason(
                                title: "\(contact.givenName) \(contact.familyName)",
                                type: .request,
                                frequency: .one,
                                period: .week
                            )
                        }
                    }
                }
            }
            .navigationTitle("Novo Motivo")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        Task {
                            await vm.addReason(title: title, type: type, frequency: frequency, period: period)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AddReasonView(vm: ReasonViewModel())
}
