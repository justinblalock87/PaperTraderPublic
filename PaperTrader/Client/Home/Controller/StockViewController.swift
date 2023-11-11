//
//  StockViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import UIKit

class StockViewController: UIViewController {

    var stock: Stock!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = stock.name
        
        let stockView = attachSwiftUIView(rootView: StockPage(stock: stock))
        stockView.rootView.segueBuySell = { (action, stock) in
            self.performSegue(withIdentifier: "segueBuySell", sender: (action, stock))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBuySell" {
            if let buySellVC = segue.destination as? BuySellViewController {
                if sender != nil, let (action, stock) = sender as? (String, Stock) {
                    buySellVC.action = action
                    buySellVC.stock = stock
                }
            }
        }
    }
}
