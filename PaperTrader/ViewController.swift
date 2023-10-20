//
//  ViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for auth changes
        listen()
    }

    func listen() {
        authHandle = Auth.auth().addStateDidChangeListener { _, user in
            let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
            if user?.uid != nil {
                NavigationManager.toHomeScreen(window: window)
            } else {
                NavigationManager.showSignIn(window: window)
            }
        }
    }
}
