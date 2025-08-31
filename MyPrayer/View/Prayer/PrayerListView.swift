//
//  PrayerListView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct PrayerListView: View {
    @StateObject private var vm = PrayerViewModel()
    @ObservedObject var reasonVM: ReasonViewModel

    var body: some View {
        NavigationSplitView {
            if vm.prayers.isEmpty && vm.error == false {
                Spacer()
                ProgressView("Carregando orações…")
                Spacer()
            } else {
                List {
                    ForEach(vm.prayers) { prayer in
                        NavigationLink(destination: PrayerDetailView(prayer: prayer, vm: vm)) {
                            VStack(alignment: .leading) {
                                Text(prayer.title).font(.headline)
                            }
                        }
                    }
                }
                .navigationTitle("Orações")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            Task {
                                let reasons = Array(reasonVM.reasons.shuffled().prefix(10))
                                await vm.addPrayer(
                                    title: Date().description,
                                    reasons: reasons
                                )
                            }
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .refreshable {
                    Task {
                        await vm.fetchPrayers()
                    }
                }
            }
        } detail: {
            Text("Seleciona uma oração na lista para ver os detalhes.")
        }

    }
}

#Preview {
    PrayerListView(reasonVM: ReasonViewModel())
}
