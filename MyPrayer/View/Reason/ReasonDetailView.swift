//
//  ReasonDetailView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct ReasonDetailView: View {
    let reason: Reason
    @ObservedObject var vm: ReasonViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var status: ReasonStatus
    @State private var notes: String
    
    init(reason: Reason, vm: ReasonViewModel) {
        self.reason = reason
        self.vm = vm
        _status = State(initialValue: reason.status)
        _notes = State(initialValue: reason.notes ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Informações")) {
                Text(reason.title)
                    .font(.headline)
                Text("Tipo: \(reason.type.rawValue)")
                Text("Frequência: \(reason.frequency.rawValue)")
            }
            
            Section(header: Text("Notas")) {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
            
            Section(header: Text("Status")) {
                Picker("Status", selection: $status) {
                    ForEach(ReasonStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Detalhes")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    vm.updatePrayer(id: reason.id, status: status, notes: notes)
                    dismiss()
                }
            }
        }
    }
}
