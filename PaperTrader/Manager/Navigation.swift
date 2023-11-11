//
//  Navigation.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import UIKit

class NavigationManager {

    static func toHomeScreen(window: UIWindow?) {
        NavigationManager.setWindowRootViewController(storyboardName: "HomeStoryboard",
                                                      viewControllerIdentifier: "HomeNavigationController",
                                                      window: window)
    }
    
    static func toHomeScreen(viewController: UIViewController) {
        NavigationManager.presentViewController(fromController: viewController,
                                                storyboardName: "HomeStoryboard",
                                                viewControllerIdentifier: "HomeNavigationController")
    }
    
    static func showSignIn(window: UIWindow?) {
         NavigationManager.setWindowRootViewController(storyboardName: "AuthStoryboard",
                                                       viewControllerIdentifier: "SignInViewController",
                                                       window: window)
    }
    
    static func presentViewController(fromController: UIViewController, storyboardName: String, viewControllerIdentifier: String) {
        DispatchQueue.main.async {
            let mainStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let toViewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
            toViewController.modalPresentationStyle = .fullScreen
            fromController.present(toViewController, animated: true, completion: nil)
        }
    }

    static func setWindowRootViewController(storyboardName: String, viewControllerIdentifier: String, window: UIWindow?) {
        DispatchQueue.main.async {
            let mainStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
    }
}
