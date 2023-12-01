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
        var request = HTTPRequest(method: .post, url: URL(string: serverURL + "social/post")!)
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
        var request = HTTPRequest(method: .post, url: URL(string: serverURL + "social/rating")!)
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
        var request = HTTPRequest(method: .post, url: URL(string: serverURL + "stock/buy")!)
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
        var request = HTTPRequest(method: .post, url: URL(string: serverURL + "stock/sell")!)
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
    
    static func fetchStock(symbol: String) async throws -> Stock {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            throw RuntimeError.runtimeError("not logged in")
        }
        let currentUser = try await UserManager.getCurrentUser()
        
        var components = URLComponents(string: serverURL + "stock/get")!
        let parameters = ["userId": uid, "accountName": currentUser.activePaperAccount, "symbol": symbol]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving stock with symbol \(symbol)")
        }
        let data = JSON.dataToDict(data: responseBody)
        guard let stock = data["stock"] as? [String: Any], let name = stock["name"] as? String, let symbol = stock["symbol"] as? String else {
            throw RuntimeError.runtimeError("Error retrieving stock with symbol \(symbol)")
        }
        print(name)
        return Stock(name: name, symbol: symbol)
    }
    
    static func fetchStockList(symbols: [String]) async throws -> [Stock] {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            throw RuntimeError.runtimeError("not logged in")
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: serverURL + "stock/snapshots")!
        let parameters = ["userId": uid, "accountName": currentUser.activePaperAccount, "symbols": symbols.joined(separator: ",")]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving stocks with symbol \(symbols)")
        }
        var stocks: [Stock] = []
        let data = JSON.dataToDict(data: responseBody)
        if let snapshots = data["snapshots"] as? [[String: Any]] {
            for snapshot in snapshots {
                if let symbol = snapshot["symbol"] as? String, let prevcloseprice = snapshot["prevcloseprice"] as? Double, let closeprice = snapshot["closeprice"] as? Double, let name = snapshot["name"] as? String {
                    stocks.append(Stock(name: name, symbol: symbol, price: closeprice, percentageChange: ((closeprice - prevcloseprice) / prevcloseprice) * 100))
                }
            }
        }
        return stocks
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
        var components = URLComponents(string: serverURL + "stock/history")!
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
    
    static func fetchCompanyNames(symbols: [String]) async throws -> [String: String] {
        var components = URLComponents(string: serverURL + "stock/company")!
        let parameters = ["symbols": symbols.joined(separator: ",")]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving stocks with symbol \(symbols)")
        }
        var companyNames: [String: String] = [:]
        let data = JSON.dataToDict(data: responseBody)
        if let names = data["companies"] as? [String: String] {
            companyNames = names
        }
        return companyNames
    }
    
    static func fetchPortfolioHistory() async throws -> (Double, Double, [PortfolioData]) {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return (0,0,[])
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: serverURL + "account/portfolioHistory")!
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
    
    static func getTopMovers() async throws -> [Stock] {
        let headers = [
          "accept": "application/json",
          "APCA-API-KEY-ID": "PKN9SZMENXIN9GSE4YDW",
          "APCA-API-SECRET-KEY": "v2tD8rb2QiCNRUtpOgNt27HhlIrGALqNqK7W1pnv"
        ]

        var request = URLRequest(url: NSURL(string: "https://data.alpaca.markets/v1beta1/screener/stocks/movers?top=10")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        var stocks: [Stock] = []
        let (responseBody, _) = try await URLSession.shared.data(for: request)
        let data = JSON.dataToDict(data: responseBody)
        if let gainers = data["gainers"] as? [[String: Any]] {
            for gainer in gainers {
                if let change = gainer["percent_change"] as? Double, let price = gainer["price"] as? Double, let symbol = gainer["symbol"] as? String {
                    stocks.append(Stock(name: "", symbol: symbol, price: price, percentageChange: change))
                }
            }
        }
        let companyNames = try? await fetchCompanyNames(symbols: stocks.map({ $0.symbol }))
        stocks.forEach({ $0.name = companyNames?[$0.symbol] ?? ""})
        return stocks
    }
    
    static func getAccount() async throws -> AccountDetails? {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return nil
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: serverURL + "account/getAccount")!
        let parameters = ["userId": uid, "accountName": currentUser.activePaperAccount]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving account")
        }
        
        let data = JSON.dataToDict(data: responseBody)
        if let account = data["account"] as? [String: Any], let equity = account["equity"] as? String, let buyingPower = account["buying_power"] as? String, let cash = account["cash"] as? String {
            return AccountDetails(equity: equity, buyingPower: buyingPower, cash: cash)
        }
        return nil
    }
    
    static func getAccountOrders() async throws -> [Order] {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return []
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: serverURL + "account/getOrders")!
        let parameters = ["userId": uid, "accountName": currentUser.activePaperAccount]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving account")
        }
        
        var activities: [Order] = []
        let data = JSON.dataToDict(data: responseBody)
        if let tivs = data["orders"] as? [[String: Any]] {
            for activity in tivs {
                if let quantity = activity["qty"] as? String,
                    let side = activity["side"] as? String,
                    let symbol = activity["symbol"] as? String,
                    let id = activity["id"] as? String,
                    let timestamp = activity["created_at"] as? String {
                    let price = activity["filled_avg_price"] as? String ?? ""
                    activities.append(Order(id: id, timestamp: timestamp, quantity: quantity, symbol: symbol, side: side, price: price, filled: !price.isEmpty))
                }
            }
        }
        return activities
    }
    
    static func getNews(symbols: [String]) async throws -> [News] {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return []
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: "https://data.alpaca.markets/v1beta1/news")!
        let parameters = ["symbols": symbols.joined(separator: ","), "limit": "5"]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        var request = HTTPRequest(method: .get, url: components.url!)
        request.headerFields[.accept] = "application/json"
        request.headerFields[.alpacaAPIKey] = "PKN9SZMENXIN9GSE4YDW"
        request.headerFields[.alpacaPrivateKey] = "v2tD8rb2QiCNRUtpOgNt27HhlIrGALqNqK7W1pnv"
        
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving account")
        }
        var newsReturn: [News] = []
        let data = JSON.dataToDict(data: responseBody)
        if let newsStories = data["news"] as? [[String: Any]] {
            for news in newsStories {
                if let id = news["id"] as? Int64 {
                    newsReturn.append(News(id: id, author: news["author"] as? String, url: news["url"] as? String, headline: news["headline"] as? String, createdAt: news["created_at"] as? String, source: news["source"] as? String))
                }
            }
        }
        print(newsReturn.count)
        return newsReturn
    }
    
    static func getPositions() async throws -> [Position] {
        guard let uid = AuthManager.uid() else {
            print("user not logged in")
            return []
        }
        let currentUser = try await UserManager.getCurrentUser()
        var components = URLComponents(string: serverURL + "account/positions")!
        let parameters = ["userId": uid, "accountName": currentUser.activePaperAccount]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
            // Handle error
            print("response error", response)
            throw RuntimeError.runtimeError("Error retrieving account")
        }
        
        var positions: [Position] = []
        let data = JSON.dataToDict(data: responseBody)
        if let pos = data["positions"] as? [[String: Any]] {
            for position in pos {
                if let quantity = position["qty"] as? String,
                    let profit = position["unrealized_pl"] as? String,
                    let symbol = position["symbol"] as? String,
                    let assetId = position["asset_id"] as? String,
                    let marketValue = position["market_value"] as? String {
                    positions.append(Position(assetId: assetId, symbol: symbol, quantity: quantity, marketValue: marketValue, profit: profit))
                }
            }
        }
        return positions
    }
    
    static func submitFeedback(text: String) async throws {
        try await db.collection("Feedback").document(UUID().uuidString).setData(["feedback": text])
    }
}

extension HTTPField.Name {
    static let alpacaAPIKey = Self("APCA-API-KEY-ID")!
    static let alpacaPrivateKey = Self("APCA-API-SECRET-KEY")!
}
