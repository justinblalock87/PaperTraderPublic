//
//  StockListItem.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import SwiftUI

struct StockListItem: View {
    
    let stock: Stock
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(stock.name)
                        .font(.headline)
                    Text(stock.symbol)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    if let price = stock.price {
                        Text("$\(String(format: "%.2f", price))")
                            .font(.headline)
                    }
                    if let percentageChange = stock.percentageChange {
                        Text("\(percentageChange, specifier: "%.2f")%")
                            .font(.subheadline)
                            .foregroundColor(percentageChange > 0 ? .green : .red)
                    }
                }
            }
        }
    }
}

#Preview {
    StockListItem(stock: Stock(name: "Apple", symbol: "AAPL"))
}
