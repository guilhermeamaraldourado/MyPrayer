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
    
    var body: some View {
        NavigationView {
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
        }
    }
}

#Preview {
    AnsweredReasonsView(vm: ReasonViewModel())
}
