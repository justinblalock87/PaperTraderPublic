//
//  NewsView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/7/23.
//

import SwiftUI

struct NewsView: View {
    
    @ObservedObject var vm: StockPageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("News")
                    .font(.system(size: 30, weight: .bold))
                InfoView(infoText: "Traders often find it helpful to use the latest news in order to make decisions about buying and selling stocks. Signs of a company flourishing could be a positive indicator for increasing stock value. On the other hand, a comapany faltering could spell danger.")
            }
            .padding(.bottom, 10)
            VStack {
                ForEach(vm.news) { story in
                    NewsItem(news: story)
                        .padding(.vertical, 10)
                }
            }
        }
    }
}

struct NewsItem: View {
    
    @Environment(\.openURL) private var openURL
    
    let news: News
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                if let url = URL(string: news.url) {
                    openURL(url)
                }
            }, label: {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(news.source)
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.leading)
                        Text("• " + news.createdAt)
                            .font(.system(size: 20, weight: .medium))
                    }
                    HStack {
                        Text(news.headline)
                            .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                            .font(.system(size: 18, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                        Spacer()
                    }
                }
            })
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NewsView(vm: StockPageViewModel(stock: Stock(name: "Apple Inc.", symbol: "AAPL", price: 176.09, percentageChange: -2.68)))
}
