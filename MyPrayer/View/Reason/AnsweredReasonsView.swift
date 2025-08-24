//
//  AnsweredReasons.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct AnsweredReasonsView: View {
    @ObservedObject var vm: ReasonViewModel
    @State private var showingAddPrayer = false
    @State private var searchText = String()
    
    var filteredReasons: [Reason] {
        if searchText.isEmpty {
            return vm.reasons
        } else {
            return vm.reasons.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(vm.reasons) { reason in
                    if reason.status == .answered {
                        NavigationLink(destination: ReasonDetailView(reason: reason,vm: vm)) {
                            VStack(alignment: .leading) {
                                Text(reason.title).font(.headline)
                                Text(reason.type.rawValue).font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Respondidas")
            .searchable(text: $searchText, prompt: "Buscar oração respondida")
            .refreshable {
                Task {
                    await vm.fetchReasons()
                }
            }
        } detail: {
            Text("Selecione um motivo de oração respondido para mais detalhes.")
        }
    }
}

#Preview {
    AnsweredReasonsView(vm: ReasonViewModel())
}
