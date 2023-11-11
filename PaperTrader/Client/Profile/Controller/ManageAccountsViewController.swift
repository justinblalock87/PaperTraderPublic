//
//  ManageAccountsViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import UIKit

class ManageAccountsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let manageAccountsView = attachSwiftUIView(rootView: ManageAccountsView())
        manageAccountsView.rootView.dismissCallback = {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
