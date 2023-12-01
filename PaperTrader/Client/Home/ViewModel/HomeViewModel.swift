//
//  HomeViewModel.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var stocks = [Stock]()
    @Published var topMovers = [Stock]()
    
    let defaultSymbols = ["AAPL", "TSLA", "META", "BA", "DIS", "GE", "NKE",
                          "SBUX", "TMUS", "AMD", "AMC", "ABNB", "ADBE", "NVDA", "GPN",
                        "MSFT", "WMT", "PFE", "MTU", "INTC", "PEP"]
    let stockList = [Stock(name: "Apple Inc.", symbol: "AAPL", price: 176.09, percentageChange: -2.68),
                     Stock(name: "The Boeing Company", symbol: "BA", price: 187.07, percentageChange: 2.14),
                     Stock(name: "Berkshire Hathaway Inc.", symbol: "BRK.A", price: 345.58, percentageChange: -0.65),
                     Stock(name: "The Walt Disney Company", symbol: "DIS", price: 85.60, percentageChange: -0.11),
                     Stock(name: "General Electric Company", symbol: "GE", price: 109.37, percentageChange: 0.25),
                     Stock(name: "NIKE, Inc.", symbol: "NKE", price: 103.03, percentageChange: 0.99),
                     Stock(name: "Starbucks Corporation", symbol: "SBUX", price: 93.59, percentageChange: -0.06),
                     Stock(name: "T-Mobile US, Inc.", symbol: "TMUS", price: 142.04, percentageChange: -1.20),]
    
    func searchForStock(symbol: String) async throws -> [Stock] {
        return try await StockManager.fetchStockList(symbols: [symbol])
    }
    
    func fetchStockList() async throws {
        let fetchedStocks = try await StockManager.fetchStockList(symbols: defaultSymbols)
        DispatchQueue.main.async { [weak self] in
            self?.stocks = fetchedStocks.sorted(by: { $0.symbol < $1.symbol })
        }
    }
    
    func getTopMovers() async throws {
        let topMovers = try await StockManager.getTopMovers()
        DispatchQueue.main.async { [weak self] in
            self?.topMovers = topMovers.sorted(by: { $0.symbol < $1.symbol })
        }
    }
}
