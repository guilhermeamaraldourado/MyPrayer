//
//  PrayerListView.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

struct PrayerListView: View {
    @StateObject private var vm = PrayerViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.prayers) { prayer in
                    VStack(alignment: .leading) {
                        Text(prayer.title).font(.headline)
                    }
                }
            }
        }
        .navigationTitle("Minhas orações")
    }
}

#Preview {
    PrayerListView()
}
