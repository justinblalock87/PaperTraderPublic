//
//  UserManager.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import FirebaseFirestore

class UserManager {
    
    static let db = Firestore.firestore()
    
    static func getCurrentUser() async throws -> User {
        guard let uid = AuthManager.uid() else {
            return User()
        }
        let user = try await db.collection("users").document(uid).getDocument()
        return User(snapshot: user)
    }
}
