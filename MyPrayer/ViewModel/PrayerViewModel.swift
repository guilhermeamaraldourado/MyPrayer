//
//  PrayerViewModel.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import Foundation
import CloudKit

@MainActor
class PrayerViewModel: ObservableObject {
    @Published var prayers: [Prayer] = []
    @Published var error = false
    private var database = CKContainer.default().privateCloudDatabase
    
    init() {
        Task {
            await fetchPrayers()
        }
    }
    
    func fetchPrayers() async {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Prayer", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let (results, _) = try await database.records(matching: query)
            prayers = results.compactMap { _, result in
                switch result {
                case .success(let record):
                    return Prayer(record: record)
                case .failure(let error):
                    print("Erro ao buscar registro: \(error.localizedDescription)")
                    self.error = true
                    return nil
                }
            }
        } catch {
            print("Erro na consulta: \(error.localizedDescription)")
            self.error = true
        }
    }
    
    func fetchReasons(for prayer: Prayer) async -> [Reason] {
        guard !prayer.refsReasons.isEmpty else { return [] }
        
        var reasons: [Reason] = []
        await withTaskGroup(of: Reason?.self) { group in
            for ref in prayer.refsReasons {
                group.addTask {
                    do {
                        let record = try await self.database.record(for: ref.recordID)
                        return Reason(record: record)
                    } catch {
                        print("Erro ao buscar Reason \(ref.recordID): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            
            for await reason in group {
                if let reason = reason {
                    reasons.append(reason)
                }
            }
        }
        return reasons
    }

    func addPrayer(title: String, reasons: [Reason]) async {
        let refs = reasons.map { CKRecord.Reference(recordID: $0.id, action: .none) }
        let prayer = Prayer(
            id: CKRecord.ID(),
            title: title,
            refsReasons: refs,
            createdAt: Date()
        )
        do {
            let _ = try await database.save(prayer.toRecord())
            prayers.insert(prayer, at: 0)
        } catch {
            print("Erro ao salvar: \(error.localizedDescription)")
        }
    }
}
