//
//  AddReasonView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct AddReasonView: View {
    @ObservedObject var vm: ReasonViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var type: ReasonType = .request
    @State private var frequency: Frequency = .daily
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Título do motivo", text: $title)
                
                Picker("Tipo", selection: $type) {
                    ForEach(ReasonType.allCases, id: \.self) { Text($0.rawValue) }
                }
                
                Picker("Frequência", selection: $frequency) {
                    ForEach(Frequency.allCases, id: \.self) { Text($0.rawValue) }
                }
            }
            .navigationTitle("Novo Motivo")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        Task {
                            await vm.addReason(title: title, type: type, frequency: frequency)
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

