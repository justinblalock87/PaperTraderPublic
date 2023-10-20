//
//  Stock.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import Foundation

class Stock {
    
    // ex: Apple
    let name: String
    // ex: AAPL
    let symbol: String
    
    let price: Double?
    let percentageChange: Double?
    
    init(name: String, symbol: String, price: Double? = nil, percentageChange: Double? = nil) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.percentageChange = percentageChange
    }
}
