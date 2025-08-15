//
//  PrayerViewModel.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import SwiftUI

class PrayerViewModel: ObservableObject {
    @Published var prayers: [Prayer] = []
    
    func addPrayer(title: String, reasons: [Reason]) {
        let newPrayer = Prayer(
            id: UUID(),
            title: title,
            reasons: reasons,
            createdAt: Date()
        )
        prayers.append(newPrayer)
    }
}
