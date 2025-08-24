//
//  Reason.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 23/08/25.
//

import Foundation
import CloudKit

struct Prayer: Identifiable {
    var id: CKRecord.ID
    var title: String
    var reasons: [Reason]?
    var createdAt: Date
    var refsReasons: [CKRecord.Reference]

    init(id: CKRecord.ID, title: String, refsReasons: [CKRecord.Reference], createdAt: Date) {
        self.id = id
        self.title = title
        self.refsReasons = refsReasons
        self.createdAt = createdAt
    }

    init(record: CKRecord) {
        id = record.recordID
        title = record["title"] as? String ?? ""
        createdAt = record["createdAt"] as? Date ?? Date()
        refsReasons = record["reasons"] as? [CKRecord.Reference] ?? []
    }

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Prayer", recordID: id)
        record["title"] = title as CKRecordValue
        record["createdAt"] = createdAt as CKRecordValue
        record["idsReasons"] = refsReasons as CKRecordValue
        return record
    }

}
