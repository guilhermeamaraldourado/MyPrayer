//
//  Prayer.swift
//  MyPrayer
//
//  Created by Guilherme Amaral Dourado on 13/08/25.
//

import UIKit

struct Prayer: Identifiable {
    var id: UUID
    var title: String
    var reasons: [Reason]
    var createdAt: Date
}
