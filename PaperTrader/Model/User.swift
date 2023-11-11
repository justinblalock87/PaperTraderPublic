//
//  User.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class User: ObservableObject, Identifiable {
    @Published var uid: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var profilePictureURL: String = ""
    @Published var activePaperAccount: String = ""
    @Published var reliabilityScore: Int = 0
    var tempProfilePicture: UIImage?
    
    convenience init(snapshot: DocumentSnapshot) {
        self.init()
        self.uid = snapshot.documentID
        self.name = snapshot.data()?["name"] as? String ?? ""
        self.username = snapshot.data()?["username"] as? String ?? ""
        self.profilePictureURL = snapshot.data()?["profilePictureURL"] as? String ?? ""
        self.activePaperAccount = snapshot.data()?["activeAccount"] as? String ?? ""
        self.reliabilityScore = snapshot.data()?["reliability"] as? Int ?? 0
    }
}
