//
//  WatchList.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/20/23.
//

import SwiftUI
import Foundation

struct WatchList: View {
    
    @ObservedObject var vm: HomeViewModel
    @AppStorage("watchlist", store: .standard) var stocks: String = ""
    
    let segueStock: ((Stock) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Watchlist")
                .font(.system(size: 30, weight: .semibold, design: .default))
                .foregroundStyle(.white)
                .padding(.bottom, 20)
            
            ForEach(Array(filterStocks(stocks: stocks).enumerated()), id: \.1.symbol) { (i, stock) in
                Button(action: {
                    segueStock?(stock)
                }, label: {
                    StockListItem(stock: stock)
                })
                Divider()
            }
        }
    }
    
    func filterStocks(stocks: String) -> [Stock] {
        return vm.stocks.filter({ stocks.components(separatedBy: ",").firstIndex(of: $0.symbol) != nil })
    }
}

//#Preview {
//    WatchList(segueStock: nil)
//}
