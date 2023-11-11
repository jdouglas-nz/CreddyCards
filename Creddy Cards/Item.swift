//
//  Item.swift
//  Creddy Cards
//
//  Created by John Douglas on 11/11/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
