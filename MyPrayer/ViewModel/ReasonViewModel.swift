//
//  ReasonViewModel.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import Foundation
import CloudKit

@MainActor
class ReasonViewModel: ObservableObject {
    @Published var reasons: [Reason] = []
    private var database = CKContainer.default().privateCloudDatabase
    
    init() {
        Task {
            await fetchReasons()
        }
    }

    func fetchReasons() async {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Reason", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let (results, _) = try await database.records(matching: query)
            reasons = results.compactMap { _, result in
                switch result {
                case .success(let record):
                    return Reason(record: record)
                case .failure(let error):
                    print("Erro ao buscar registro: \(error.localizedDescription)")
                    return nil
                }
            }
        } catch {
            print("Erro na consulta: \(error.localizedDescription)")
        }
    }

    func addReason(title: String, type: ReasonType, frequency: Frequency) async {
        let reason = Reason(
            id: CKRecord.ID(),
            title: title,
            type: type,
            notes: nil,
            frequency: frequency,
            status: .pending,
            createdAt: Date()
        )
        
        do {
            let _ = try await database.save(reason.toRecord())
            reasons.insert(reason, at: 0)
        } catch {
            print("Erro ao salvar: \(error.localizedDescription)")
        }
    }

    func updateReason(_ reason: Reason) async {
        do {
            let _ = try await database.save(reason.toRecord())
            if let index = reasons.firstIndex(where: { $0.id == reason.id }) {
                reasons[index] = reason
            }
        } catch {
            print("Erro ao atualizar: \(error.localizedDescription)")
        }
    }
    
    func deleteReasonAt(index: Int) async {
        do {
            let _ = try await database.deleteRecord(withID: reasons[index].id)
            reasons.remove(at: index)
        } catch {
            print("Erro ao deletar: \(error.localizedDescription)")
        }
    }
}
