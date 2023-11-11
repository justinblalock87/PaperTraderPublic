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
    let authorReliability: Int
    var likes: Int
    let likers: [String]
    let dislikers: [String]
    
    init(id: String, authorID: String, authorUsername: String, timestamp: Int, content: String, authorReliability: Int, likes: Int, likers: [String], dislikers: [String]) {
        self.id = id
        self.authorID = authorID
        self.authorUsername = authorUsername
        self.timestamp = timestamp
        self.content = content
        self.authorReliability = authorReliability
        self.likes = likes
        self.likers = likers
        self.dislikers = dislikers
    }
    
    convenience init?(snapshot: DocumentSnapshot) async throws {
        let id = snapshot.documentID
        let authorID = snapshot.data()?["userId"] as? String ?? "No title"
        let content = snapshot.data()?["content"] as? String ?? "..."
        let timestamp = snapshot.data()?["timestamp"] as? Int ?? 0
        let authorUsername = snapshot.data()?["username"] as? String ?? ""
        let likes = snapshot.data()?["likes"] as? Int ?? 0
        let likers = snapshot.data()?["likers"] as? [String] ?? []
        let dislikers = snapshot.data()?["dislikers"] as? [String] ?? []
        let otherUser = try await UserManager.getUser(uid: authorID)
        
        self.init(id: id, authorID: authorID, authorUsername: authorUsername, timestamp: timestamp, content: content, authorReliability: otherUser.reliabilityScore, likes: likes, likers: likers, dislikers: dislikers)
    }
}
