//
//  Reason.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import Foundation
import CloudKit

struct Reason: Identifiable {
    var id: CKRecord.ID
    var title: String
    var type: ReasonType
    var notes: String?
    var frequency: Frequency
    var deadline: Date?
    var status: ReasonStatus
    var createdAt: Date
    
    init(id: CKRecord.ID, title: String, type: ReasonType, notes: String? = nil, frequency: Frequency, deadline: Date? = nil, status: ReasonStatus, createdAt: Date) {
        self.id = id
        self.title = title
        self.type = type
        self.notes = notes
        self.frequency = frequency
        self.deadline = deadline
        self.status = status
        self.createdAt = createdAt
    }
    
    init(record: CKRecord) {
        id = record.recordID
        title = record["title"] as? String ?? ""
        type = ReasonType(rawValue: record["type"] as? String ?? "") ?? .request
        notes = record["notes"] as? String
        frequency = Frequency(rawValue: record["frequency"] as? String ?? "") ?? .daily
        status = ReasonStatus(rawValue: record["status"] as? String ?? "") ?? .pending
        createdAt = record["createdAt"] as? Date ?? Date()
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Reason", recordID: id)
        record["title"] = title as CKRecordValue
        record["type"] = type.rawValue as CKRecordValue
        record["notes"] = notes as CKRecordValue?
        record["frequency"] = frequency.rawValue as CKRecordValue
        record["status"] = status.rawValue as CKRecordValue
        record["createdAt"] = createdAt as CKRecordValue
        return record
    }
}

enum ReasonType: String, CaseIterable {
    case request = "Pedido"
    case gratitude = "Gratidão"
    case worship = "Adoração"
}

enum Frequency: String, CaseIterable {
    case daily = "Diário"
    case weekly = "Semanal"
    case monthly = "Mensal"
}

enum ReasonStatus: String, CaseIterable {
    case pending = "Pendente"
    case partial = "Parcialmente atendido"
    case answered = "Atendido"
}

enum Period: String, CaseIterable, Identifiable {
    case daily = "dia"
    case week = "semana"
    case month = "mês"
    case year = "ano"
    
    var id: String { self.rawValue }
}

enum Quantity: String, CaseIterable, Identifiable {
    case one = "uma vez"
    case two = "duas vezes"
    case three = "três vezes"
    case four = "quatro vezes"
    case five = "cinco vezes"
    
    var id: String { self.rawValue }
    
    func getValue() -> Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        }
    }
}
