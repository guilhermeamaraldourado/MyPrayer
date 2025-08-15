//
//  MyPrayerApp.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 14/08/25.
//

import SwiftUI
import SwiftData

@main
struct MyPrayerApp: App {
    @StateObject private var vm = ReasonViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                PrayerListView()
                    .tabItem {
                        Label("Orações", systemImage: "icloud.and.arrow.up")
                    }
                ReasonListView(vm: vm)
                    .tabItem {
                        Label("Motivos", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                    }
                AnsweredReasonsView(vm: vm)
                    .tabItem {
                        Label("Respondidas", systemImage: "icloud.and.arrow.down")
                    }
            }
        }
    }
}
