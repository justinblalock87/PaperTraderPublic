//
//  UserManager.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserManager {
    
    static let db = Firestore.firestore()
    
    static func getCurrentUser() async throws -> User {
        guard let uid = AuthManager.uid() else {
            return User()
        }
        let user = try await db.collection("User").document(uid).getDocument()
        return User(snapshot: user)
    }
    
    static func getUser(uid: String) async throws -> User {
        let user = try await db.collection("User").document(uid).getDocument()
        return User(snapshot: user)
    }
    
    static func updateProfilePicture(image: UIImage) async throws {
        guard let uid = AuthManager.uid() else {
            throw RuntimeError.runtimeError("not logged in")
        }
        
        let downloadURL = try await saveImageToStorage(image: image, path: "profile_images/" + uid)
        try await db.collection("User").document(uid).updateData(["profilePictureURL": downloadURL])
    }
    
    /**
     Saves a UIImage to Firebase Storage at the specified path.
     - parameters:
            - image: the image to be saved.
            - path: The firebase storage path (under the main bucket) to store the image at
     - returns: The download url of the image
     */
    static func saveImageToStorage(image: UIImage, path: String) async throws -> String {
        let storageRef = Storage.storage().reference().child(path)
        let img = image.jpegData(compressionQuality: 0.01)

        return try await withCheckedThrowingContinuation { continuation in
            storageRef.putData(img!, metadata: nil) { _, error  in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                storageRef.downloadURL(completion: { url, err in
                    guard let urlString = url?.absoluteString, err == nil else {
                        continuation.resume(throwing: err!)
                        return
                    }
                    continuation.resume(returning: urlString)
                })
            }
        }
    }
    
    static func setPaperAccount(accountName: String) async throws {
        guard let uid = AuthManager.uid() else {
            throw RuntimeError.runtimeError("not logged in")
        }
        
        try await db.collection("User").document(uid).updateData(["activeAccount": accountName])
    }
}
