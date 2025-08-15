//
//  Reason.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import UIKit

struct Reason: Identifiable, Codable {
    var id: UUID
    var title: String
    var type: ReasonType
    var notes: String?
    var frequency: Frequency
    var deadline: Date?
    var status: ReasonStatus
    var createdAt: Date
}

enum ReasonType: String, CaseIterable, Codable {
    case request = "Pedido"
    case gratitude = "Gratidão"
    case worship = "Adoração"
}

enum Frequency: String, CaseIterable, Codable {
    case daily = "Diário"
    case weekly = "Semanal"
    case monthly = "Mensal"
}

enum ReasonStatus: String, CaseIterable, Codable {
    case pending = "Pendente"
    case partial = "Parcialmente atendido"
    case answered = "Atendido"
}
