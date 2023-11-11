//
//  ProfileViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/4/23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileView = attachSwiftUIView(rootView: ProfileView())
        profileView.rootView.segueToAccounts = {
            self.performSegue(withIdentifier: "segueAccounts", sender: nil)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
