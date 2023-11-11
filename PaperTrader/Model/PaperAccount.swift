//
//  PaperAccount.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import Foundation

class PaperAccount: Identifiable {
    
    var name: String
    var alpacaKey: String
    var alpacaSecretKey: String
    
    init(name: String, alpacaKey: String, alpacaSecretKey: String) {
        self.name = name
        self.alpacaKey = alpacaKey
        self.alpacaSecretKey = alpacaSecretKey
    }
    
    convenience init?(account: [String: Any]) {
        guard let name = account["accountName"] as? String,
              let alpacaKey = account["alpacaKey"] as? String,
              let alpacaSecretKey = account["alpacaSecretKey"] as? String else {
            return nil
        }
        self.init(name: name, alpacaKey: alpacaKey, alpacaSecretKey: alpacaSecretKey)
    }
}
