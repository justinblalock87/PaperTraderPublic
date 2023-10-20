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
        return snapshot.documents.compactMap({ Comment(snapshot: $0) })
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
}
