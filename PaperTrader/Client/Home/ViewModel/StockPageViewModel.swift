//
//  StockPageViewModel.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import Foundation

@MainActor
class StockPageViewModel: ObservableObject {
    
    @Published var comments = [Comment]()
    @Published var news = [News(id: 1, author: "Reuters", url: "the", headline: "Touchdown For Shopping: Amazon's Innovative Black Friday Football Game Integrates Commerce And Content", createdAt: "2023-11-24T14:03:22Z", source: "Reuters"), News(id: 1, author: "Reuters", url: "the", headline: "Touchdown For Shopping: Amazon's Innovative Black Friday Football Game Integrates Commerce And Content", createdAt: "2023-11-24T14:03:22Z", source: "Reuters")]
    
    @Published var inputText = ""
    
    let stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    func fetchComments() async throws {
        comments = try await StockManager.fetchComments(for: stock)
    }
    
    func fetchNews() async throws {
        news = try await StockManager.getNews(symbols: [stock.symbol])
    }
    
    func sendMessage() {
        let textToSend = inputText
        inputText = ""
        
        Task.init {
            do {
                try await StockManager.addComment(for: stock, content: textToSend)
                try await fetchComments()
            } catch let error {
                print("error sending comment", String(describing: error))
            }
        }
    }
}
