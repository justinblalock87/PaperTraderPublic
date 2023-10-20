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
    @Published var inputText = ""
    
    let stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    func fetchComments() async throws {
        comments = try await StockManager.fetchComments(for: stock)
    }
    
    func sendMessage() {
        let textToSend = inputText
        inputText = ""
        
        Task.init {
            do {
                try await StockManager.addComment(for: stock, content: textToSend)
            } catch let error {
                print("error sending comment")
            }
        }
    }
}
