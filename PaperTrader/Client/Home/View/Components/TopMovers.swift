//
//  TopMovers.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/20/23.
//

import SwiftUI

struct TopMovers: View {
    
    @ObservedObject var vm: HomeViewModel
    
    let segueStock: ((Stock) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Top Movers")
                    .font(.system(size: 30, weight: .semibold, design: .default))
                    .foregroundStyle(.white)
                InfoView(infoText: "Top movers are stocks with the highest percentage gain in stock price from the previous day's closing price.")
                Spacer()
            }
            .padding(.bottom, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(vm.topMovers.enumerated()), id: \.1.symbol) { (i, stock) in
                        Button(action: {
                            segueStock?(stock)
                        }, label: {
                            TopMoverListItem(stock: stock)
                        })
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

struct TopMoverListItem: View {
    
    let stock: Stock
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(stock.symbol)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                if let price = stock.price {
                    Text("$\(String(format: "%.2f", price))")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(ColorTheme.goodGray)
                }
                Spacer()
            }
            
            if let percentageChange = stock.percentageChange {
                Text("\(percentageChange, specifier: "%.2f")%")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .foregroundColor(percentageChange > 0 ? .green : .red)
            }
        }
        .padding()
        .background(Color(red: 20/255, green: 20/255, blue: 20/255))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 20/255, green: 20/255, blue: 20/255), lineWidth: 0.5)
                
        }
    }
}

//#Preview {
//    TopMovers()
//}
