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
        _notes = State(initialValue: reason.notes ?? String())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Informações")) {
                Text(reason.title)
                    .font(.headline)
                Text("Tipo: \(reason.type.rawValue)")
                Text("Frequência: \(getFrequency())")
            }
            
            Section(header: Text("Notas")) {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
            
            Section(header: Text("Status")) {
                Picker("", selection: $status) {
                    ForEach(ReasonStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
        }
        .navigationTitle("Detalhes")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    Task {
                        await vm.updateReason(getUpdatedReason())
                        dismiss()
                    }
                }
                .disabled(notes == (self.reason.notes ?? String()) && status == self.reason.status)
            }
        }
    }
    
    func getFrequency() -> String {
        if reason.period == .daily {
            return "Diariamente"
        }
        
        return "\(reason.frequency.rawValue) por \(reason.period.rawValue)"
    }
    
    func getUpdatedReason() -> Reason {
        var updatedReason = reason
        updatedReason.status = status
        if status == .answered {
            var aux = notes
            aux += "\n✅ Respondida em \(formattedDate(Date()))"
            notes = aux
        }
        updatedReason.notes = notes
        return updatedReason
    }
    
    private func formattedDate(_ date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateStyle = .short
         return formatter.string(from: date)
     }
}

#Preview {
    ReasonDetailView(reason: Reason.dummy(), vm: ReasonViewModel())
}
