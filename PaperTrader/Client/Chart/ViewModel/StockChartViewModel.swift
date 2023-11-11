//
//  StockAPI.swift
//  test_stock
//
//  Created by Leul Wubete on 10/15/23.
//
import Combine
import Foundation
import HTTPTypes
import HTTPTypesFoundation

class StockChartViewModel: ObservableObject {
    let stockSymbol: String
    @Published var stockData: [StockDayData] = []
    @Published var currentPrice: Double = 0
    @Published var dragOffset: CGFloat = 0
    @Published var currentTimeframe = "Y"
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
        reload()
    }
    
    func reload() {
        Task.init {
            do {
                let data = try await StockManager.fetchStockHistory(stockSymbol: self.stockSymbol, timeframe: currentTimeframe)
                DispatchQueue.main.async {
                    self.stockData = data
                    self.currentPrice = data.last?.close ?? 0
                }
            } catch {
                print("error fetching stock history for \(stockSymbol)", error.localizedDescription)
            }
        }
    }
}


struct StockDayData: Codable {
    let close: Double
    let high: Double
    let low: Double
    let open: Double
    let date: String

    enum CodingKeys: String, CodingKey {
        case close = "ClosePrice"
        case high = "HighPrice"
        case low = "LowPrice"
        case open = "OpenPrice"
        case date = "Timestamp"
    }
}
