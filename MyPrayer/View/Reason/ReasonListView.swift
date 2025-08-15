//
//  ReasonListView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct ReasonListView: View {
    @ObservedObject var vm: ReasonViewModel
    @State private var showingAddReason = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.reasons.filter { $0.status != .answered }) { reason in
                    NavigationLink(destination: ReasonDetailView(
                        reason: reason,
                        vm: vm
                    )) {
                        VStack(alignment: .leading) {
                            Text(reason.title).font(.headline)
                            Text(reason.type.rawValue).font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Meus motivos")
            .toolbar {
                Button(action: { showingAddReason.toggle() }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddReason) {
                AddReasonView(vm: vm)
            }
        }
    }
}

#Preview {
    ReasonListView(vm: ReasonViewModel())
}
