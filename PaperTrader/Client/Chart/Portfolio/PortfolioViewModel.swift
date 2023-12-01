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
    @Published var orders: [Order] = [Order(id: "1", timestamp: "2023-11-15T17:38:41.15227Z", quantity: "20", symbol: "TSLA", side: "buy", price: "28.19", filled: true),Order(id: "2", timestamp: "2023-11-15T17:38:41.15227Z", quantity: "20", symbol: "TSLA", side: "buy", price: "28.19", filled: true)]
    @Published var positions: [Position] = [Position(assetId: "2", symbol: "AAPL", quantity: "33", marketValue: "6203.45", profit: "313.23")]
    @Published var cash: String = "100232.23"
    @Published var equity: String = "2309.34"
    @Published var buyingPower: String = "200348.45"
    @Published var loading: Bool = false
    var hasLoadedBefore = false
    
    func reload() {
        if !hasLoadedBefore {
            loading = true
        }
        Task.init {
            do {
                let vals: (Double, Double, [PortfolioData])? = try? await StockManager.fetchPortfolioHistory()
                let activities = try? await StockManager.getAccountOrders()
                let positions = try? await StockManager.getPositions()
                let accountDetails = try? await StockManager.getAccount()
                DispatchQueue.main.async {
                    self.portfolioData = vals?.2 ?? []
                    self.profit_loss = vals?.1 ?? 0
                    self.percent_change = vals?.0 ?? 0
                    self.orders = activities ?? []
                    self.positions = positions ?? []
                    self.cash = accountDetails?.cash ?? ""
                    self.equity = accountDetails?.equity ?? ""
                    self.buyingPower = accountDetails?.buyingPower ?? ""
                    self.loading = false
                    self.hasLoadedBefore = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.loading = false
                    self.hasLoadedBefore = true
                }
                print("error fetching portfolio history", String(describing: error))
            }
        }
    }
}


struct PortfolioData: Codable {
    let timestamp: Int
    let equity: Double
}
