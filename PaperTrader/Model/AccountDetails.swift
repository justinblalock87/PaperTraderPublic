//
//  AccountDetails.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import Foundation

struct AccountDetails {
    let equity: String
    let buyingPower: String
    let cash: String
    
    init(equity: String, buyingPower: String, cash: String) {
        self.equity = equity
        self.buyingPower = buyingPower
        self.cash = cash
    }
}
