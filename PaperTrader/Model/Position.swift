//
//  Position.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import Foundation

class Position: Identifiable {
    
    let assetId: String
    let symbol: String
    let quantity: String
    let marketValue: String
    let profit: String
    
    init(assetId: String, symbol: String, quantity: String, marketValue: String, profit: String) {
        self.assetId = assetId
        self.symbol = symbol
        self.quantity = quantity
        self.marketValue = marketValue
        self.profit = profit
    }
}
