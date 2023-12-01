//
//  Activity.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import Foundation

class Order: Identifiable {
    let id: String
    let timestamp: String
    let quantity: String
    let symbol: String
    let side: String
    let price: String
    let filled: Bool
    
    init(id: String, timestamp: String, quantity: String, symbol: String, side: String, price: String, filled: Bool) {
        self.id = id
        self.timestamp = timestamp.getDate()?.timeAgoDisplay() ?? ""
        self.quantity = quantity
        self.symbol = symbol
        self.side = side
        self.price = String(format: "%.2f", Double(price) ?? 0)
        self.filled = filled
    }
}
