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

    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
        Task.init {
            do {
                let data = try await fetchStockHistory(stockSymbol: stockSymbol)
                DispatchQueue.main.async {
                    self.stockData = data
                    self.currentPrice = data.last?.close ?? 0
                }
            } catch {
                print("error fetching stock history for \(stockSymbol)", error.localizedDescription)
            }
        }
    }

    func fetchStockHistory(stockSymbol: String) async throws -> [StockDayData] {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return []
        }
        
        var components = URLComponents(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/stock/history")!
        let parameters = ["userId": uid, "accountName": "Paper", "stockSymbol": stockSymbol]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return []
        }
        
        return try JSONDecoder().decode(StockHistoryResponse.self, from: responseBody).bars
    }

}


struct StockDayData: Codable {
    let close: Double
    let high: Double
    let low: Double
    let open: Double
//    let date: Date

    enum CodingKeys: String, CodingKey {
        case close = "ClosePrice"
        case high = "HighPrice"
        case low = "LowPrice"
        case open = "OpenPrice"
//        case date = "Timestamp"
    }
}
