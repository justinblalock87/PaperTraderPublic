//
//  SignInViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = attachSwiftUIView(rootView: SignInView())
        
        contentView.rootView.signInCallback = {
            NavigationManager.toHomeScreen(viewController: self)
        }
    }
}

#Preview {
    let signInVC = SignInViewController(nibName: nil, bundle: nil)
    return signInVC
}
