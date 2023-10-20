//
//  StockModel.swift
//  test_stock
//
//  Created by Leul Wubete on 10/15/23.
//
struct StockHistoryResponse: Codable {
    let success: Bool
    let bars: [StockDayData]
}

struct StockBar: Codable {
    let ClosePrice: Double
    let HighPrice: Double
    let LowPrice: Double
    let OpenPrice: Double
    let Timestamp: String
    // ... other properties if needed
}
