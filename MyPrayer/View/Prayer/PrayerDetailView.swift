//
//  PrayerDetailView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 24/08/25.
//

import SwiftUI

struct PrayerDetailView: View {
    let prayer: Prayer
    @State private var reasons: [Reason] = []
    @ObservedObject var vm: PrayerViewModel
    @Environment(\.dismiss) var dismiss
    
    init(prayer: Prayer, vm: PrayerViewModel) {
        self.prayer = prayer
        self.vm = vm
    }
    
    var body: some View {
        Form {
            Section(header: Text("Título")) {
                Text(prayer.title)
                    .font(.headline)
            }
            
            Section(header: Text("Motivos")) {
                List {
                    ForEach(reasons) { reason in
                        VStack(alignment: .leading) {
                            Text(reason.title).font(.headline)
                        }
                    }
                }
            }
        }
        .navigationTitle("Detalhes")
        .onAppear {
            Task {
                let fetched = await vm.fetchReasons(for: self.prayer)
                await MainActor.run {
                    self.reasons = fetched
                }
            }
        }
    }
}
