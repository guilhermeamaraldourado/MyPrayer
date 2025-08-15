//
//  ReasonViewModel.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

class ReasonViewModel: ObservableObject {
    @Published var reasons: [Reason] = []
    
    func addReason(title: String, type: ReasonType, frequency: Frequency) {
        let newReason = Reason(
            id: UUID(),
            title: title,
            type: type,
            notes: nil,
            frequency: frequency,
            deadline: nil,
            status: .pending,
            createdAt: Date()
        )
        reasons.append(newReason)
    }
    
    func updatePrayer(id: UUID, status: ReasonStatus, notes: String) {
        if let index = reasons.firstIndex(where: { $0.id == id }) {
            reasons[index].status = status
            reasons[index].notes = notes

            if status == .answered {
                var aux = reasons[index].notes ?? ""
                aux += "\n✅ Respondida em \(formattedDate(Date()))"
                reasons[index].notes = aux
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

}
