//
//  SettingsViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/4/23.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let settingsView = attachSwiftUIView(rootView: SettingsView())
    }
}
