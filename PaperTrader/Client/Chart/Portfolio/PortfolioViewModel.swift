//
//  PortfolioViewModel.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/6/23.
//

import Combine
import Foundation
import HTTPTypes
import HTTPTypesFoundation

class PortfolioViewModel: ObservableObject {
    @Published var portfolioData: [PortfolioData] = []
    @Published var profit_loss: Double = 0
    @Published var percent_change: Double = 0
    
    init() {
        reload()
    }
    
    func reload() {
        Task.init {
            do {
                let (profit_loss, percent_change, portfolioData) = try await StockManager.fetchPortfolioHistory()
                DispatchQueue.main.async {
                    self.portfolioData = portfolioData
                    self.profit_loss = profit_loss
                    self.percent_change = percent_change
                }
            } catch {
                print("error fetching portfolio history", String(describing: error))
            }
        }
    }
}


struct PortfolioData: Codable {
    let timestamp: Int
    let equity: Double
}
