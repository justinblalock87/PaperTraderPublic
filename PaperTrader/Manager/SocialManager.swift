//
//  SocialManager.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import Foundation
import FirebaseFirestore

class SocialManager {
    
    static let db = Firestore.firestore()
    
    static func getTopComments() async throws -> [Comment] {
        let snapshot = try await db.collection("Posts").order(by: "likes", descending: true).getDocuments()
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
        return comments.sorted(by: { $0.likes > $1.likes })
    }
}
