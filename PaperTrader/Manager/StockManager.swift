//
//  CommentManager.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import Foundation
import FirebaseFirestore
import HTTPTypes
import HTTPTypesFoundation

class StockManager {
    
    static let db = Firestore.firestore()
    
    static func fetchComments(for stock: Stock) async throws -> [Comment] {
        let snapshot = try await db.collection("Posts").whereField("stockSymbol", isEqualTo: stock.symbol).getDocuments()
        let comments = await withTaskGroup(of: Comment?.self, returning: [Comment].self, body: { taskGroup in
            var comments: [Comment] = []
            for doc in snapshot.documents {
                taskGroup.addTask {
                    do {
                        let comment = try await Comment(snapshot: doc)
                        return comment
                    } catch {
                        print("Failed to convert document to chat \(String(describing: error)) \(doc)")
                        return nil
                    }
                }
            }
            for await comment in taskGroup {
                if let comment = comment { comments.append(comment) }
            }
            return comments
        })
        return comments.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    static func addComment(for stock: Stock, content: String) async throws {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return
        }
        var request = HTTPRequest(method: .post, url: URL(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/social/post")!)
        let requestBody: [String: Any] = [
            "userId": uid,
            "stockSymbol": stock.symbol,
            "content": content
        ]
        let body = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.headerFields[.contentType] = "application/json"
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: body)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return
        }
        print(responseBody)
    }
    
    private static func upvoteComment(comment: Comment, upvote: Bool) async throws {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return
        }
        var request = HTTPRequest(method: .post, url: URL(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/social/rating")!)
        let requestBody: [String: Any] = [
            "userId": uid,
            "postId": comment.id,
            "upvote": upvote
        ]
        let body = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.headerFields[.contentType] = "application/json"
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: body)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return
        }
        print(responseBody)
    }
    
    static func likeComment(comment: Comment, like: Bool, remove: Bool) async throws {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return
        }
        let updatedCommentDoc = try await db.collection("Posts").document(comment.id).getDocument()
        guard let updatedComment = try await Comment(snapshot: updatedCommentDoc) else {
            print("could not retrieve updated comment")
            return
        }
        var datum: [String: Any] = [:]
        if like {
            if remove {
                datum = ["likes": FieldValue.increment(Int64(-1)), "likers": FieldValue.arrayRemove([uid])]
            } else {
                datum = ["likes": FieldValue.increment(Int64(1)), "likers": FieldValue.arrayUnion([uid])]
                if updatedComment.dislikers.contains(uid) {
                    datum["likes"] = FieldValue.increment(Int64(2))
                    datum["dislikers"] = FieldValue.arrayRemove([uid])
                }
            }
        } else {
            if remove {
                datum = ["likes": FieldValue.increment(Int64(1)), "dislikers": FieldValue.arrayRemove([uid])]
            } else {
                datum = ["likes": FieldValue.increment(Int64(-1)), "dislikers": FieldValue.arrayUnion([uid])]
                if updatedComment.likers.contains(uid) {
                    datum["likes"] = FieldValue.increment(Int64(-2))
                    datum["likers"] = FieldValue.arrayRemove([uid])
                }
            }
        }
        try await db.collection("Posts").document(comment.id).updateData(datum)
        if !remove {
            try await upvoteComment(comment: updatedComment, upvote: like)
        }
    }
    
    static func buyStock(stock: Stock, quantity: Int) async throws {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return
        }
        let currentUser = try await UserManager.getCurrentUser()
        var request = HTTPRequest(method: .post, url: URL(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/stock/buy")!)
        let requestBody: [String: Any] = [
            "userId": uid,
            "accountName": currentUser.activePaperAccount,
            "stockSymbol": stock.symbol,
            "quantity": quantity
        ]
        let body = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.headerFields[.contentType] = "application/json"
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: body)
        guard response.status == .ok else {
           // Handle error
            print("response error", response)
           return
        }
        print(responseBody)
    }
    
    static func sellStock(stock: Stock, quantity: Int) async throws {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return
        }
        let currentUser = try await UserManager.getCurrentUser()
        var request = HTTPRequest(method: .post, url: URL(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/stock/sell")!)
        let requestBody: [String: Any] = [
            "userId": uid,
            "accountName": currentUser.activePaperAccount,
            "stockSymbol": stock.symbol,
            "quantity": quantity
        ]
        let body = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.headerFields[.contentType] = "application/json"
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: body)
        guard response.status == .ok else {
           // Handle error
            print("response error", response)
           return
        }
        print(responseBody)
    }
    
    static func fetchStockHistory(stockSymbol: String, timeframe: String) async throws -> [StockDayData] {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return []
        }
        var timeframe = timeframe
        if timeframe == "1Y" {
            timeframe = "Y"
        } else if timeframe == "1M" {
            timeframe = "M"
        } else if timeframe == "1D" {
            timeframe = "D"
        }
        var components = URLComponents(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/stock/history")!
        let parameters = ["userId": uid, "accountName": "Paper", "stockSymbol": stockSymbol, "timeframe": timeframe]
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
    
    static func fetchPortfolioHistory() async throws -> (Double, Double, [PortfolioData]) {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return (0,0,[])
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/account/portfolioHistory")!
        let parameters = ["userId": uid, "accountName": currentUser.activePaperAccount]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return (0,0,[])
        }
        let data = JSON.dataToDict(data: responseBody)
        guard let timestamps = data["timestamp"] as? [Int], let equities = data["equity"] as? [Double], let profit_loss = data["profit_loss"] as? [Double], let profit_loss_pct = data["profit_loss_pct"] as? [Double] else {
            print("input malformed")
            return (0,0,[])
        }
        let conjoined = Array(zip(timestamps, equities))
        let profitLoss = profit_loss.last ?? 0
        let pChange = profit_loss_pct.last ?? 0.00
        return (profitLoss, pChange, conjoined.map({ PortfolioData(timestamp: $0.0, equity: $0.1)}))
    }
}
