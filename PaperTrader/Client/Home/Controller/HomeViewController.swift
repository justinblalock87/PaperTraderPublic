//
//  HomeViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeView = attachSwiftUIView(rootView: HomeView())
        homeView.rootView.segueStock = { stock in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segueStock", sender: stock)
            }
        }
        homeView.rootView.segueSettings = {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segueSettings", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueStock" {
            if let stockVC = segue.destination as? StockViewController {
                stockVC.stock = sender as? Stock
            }
        }
    }
}
