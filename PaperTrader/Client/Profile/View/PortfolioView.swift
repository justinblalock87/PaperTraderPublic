//
//  PortfolioView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @ObservedObject var portfolioVM: PortfolioViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Assets")
                .font(.system(size: 28, weight: .semibold, design: .default))
            CashView(portfolioVM: portfolioVM)
                .padding(.vertical, 10)
            
            Divider()
                .background(.white)
                .padding(.vertical, 20)
            
            HStack(alignment: .center, spacing: 4) {
                Text("Positions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                InfoView(infoText: "A position is the amount of a company's stock that you own. The market value is the amount that you would receieve if you sold all shares today.", infoLink: "https://www.investopedia.com/terms/p/position.asp#:~:text=A%20position%20is%20the%20amount,short%20securities%20with%20bearish%20intent.")
            }
            
            ForEach(portfolioVM.positions) { position in
                PositionView(position: position)
                    .padding(.vertical, 10)
            }
            .padding(.bottom, 20)
            
            Divider()
                .background(.white)
                .padding(.vertical, 20)
            
            HStack(alignment: .center, spacing: 4) {
                Text("Recent Orders")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                InfoView(infoText: "An order is when you buy or sell a stock. The fill price is the price at which the stock was bought or sold. Orders may not be filled immediately, if for instance you try to execute an order outside of trading hours.")
            }
            
            ForEach(portfolioVM.orders) { activity in
                OrderView(order: activity)
                    .padding(.vertical, 10)
            }
        }
        .foregroundStyle(.white)
    }
}

struct CashView: View {
    
    let portfolioVM: PortfolioViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Cash")
                    .foregroundStyle(ColorTheme.goodGray)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                Text("$" + portfolioVM.cash)
                    .font(.system(size: 27, weight: .semibold, design: .default))
            }
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 4) {
                    Text("Equity")
                        .foregroundStyle(ColorTheme.goodGray)
                    InfoView(infoText: "This value is cash + holding positions.")
                }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                Text("$" + portfolioVM.equity)
                    .font(.system(size: 27, weight: .semibold, design: .default))
            }
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 4) {
                    Text("Buying Power ")
                        .foregroundStyle(ColorTheme.goodGray)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                    InfoView(infoText: "Buying power is the money that you have available to purchase stocks. It is at least the amount of cash that you have in your account but that value can also be multiplied by a certain amount based on how much margin you have on your brokerage account.", infoLink: "https://www.investopedia.com/terms/b/buyingpower.asp#:~:text=Buying%20power%20is%20the%20money,times%20equity%20in%20buying%20power.")
                }
                Text("$" + portfolioVM.buyingPower)
                    .font(.system(size: 27, weight: .semibold, design: .default))
            }
        }
    }
}

struct PositionView: View {
    
    let position: Position
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(position.symbol)
                        .font(.system(size: 20, weight: .semibold, design: .default))
                    Text(position.quantity + " units")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Market Value:")
                            .foregroundStyle(ColorTheme.goodGray)
                            .font(.system(size: 13, weight: .medium, design: .default))
                        Text("$" + position.marketValue)
                            .font(.system(size: 20, weight: .semibold, design: .default))
                    }
                    
                    HStack {
                        Text("Profit/Loss:")
                            .foregroundStyle(ColorTheme.goodGray)
                            .font(.system(size: 13, weight: .medium, design: .default))
                        Text("$" + position.profit)
                            .font(.system(size: 20, weight: .semibold, design: .default))
                    }
                    
                }
            }
        }
        .foregroundStyle(.white)
    }
}

struct OrderView: View {
    
    let order: Order
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(order.symbol)
                        .font(.system(size: 20, weight: .semibold, design: .default))
                    Text(order.side.uppercased() + " " + order.quantity + " units")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(order.timestamp)
                        .foregroundStyle(ColorTheme.goodGray)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    HStack {
                        if order.filled {
                            Text("Fill Price:")
                                .foregroundStyle(ColorTheme.goodGray)
                                .font(.system(size: 13, weight: .medium, design: .default))
                            Text("$" + order.price)
                                .font(.system(size: 20, weight: .semibold, design: .default))
                        } else {
                            Text("Not filled")
                                .foregroundStyle(ColorTheme.goodGray)
                                .font(.system(size: 13, weight: .medium, design: .default))
                        }
                    }
                }
            }
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    PortfolioView(portfolioVM: PortfolioViewModel())
}
