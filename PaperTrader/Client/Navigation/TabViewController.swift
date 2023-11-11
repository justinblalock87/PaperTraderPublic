//
//  TabViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers?[0].tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), selectedImage: UIImage(named: "house.fill"))
        self.viewControllers?[1].tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), selectedImage: UIImage(named: "person.fill"))
        
        self.tabBar.clipsToBounds = true
        self.selectedIndex = 0
    }
}
