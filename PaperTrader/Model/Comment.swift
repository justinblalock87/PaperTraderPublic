//
//  Comment.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import Foundation
import FirebaseFirestore

class Comment {

    let id: String
    let authorID: String
    let authorUsername: String
    let timestamp: Int
    let content: String
    
    init(id: String, authorID: String, authorUsername: String, timestamp: Int, content: String) {
        self.id = id
        self.authorID = authorID
        self.authorUsername = authorUsername
        self.timestamp = timestamp
        self.content = content
    }
    
    convenience init?(snapshot: QueryDocumentSnapshot) {
        let id = snapshot.documentID
        let authorID = snapshot.data()["userId"] as? String ?? "No title"
        let content = snapshot.data()["content"] as? String ?? "..."
        let timestamp = snapshot.data()["timestamp"] as? Int ?? 0
        let authorUsername = snapshot.data()["username"] as? String ?? ""
        self.init(id: id, authorID: authorID, authorUsername: authorUsername, timestamp: timestamp, content: content)
    }
}
