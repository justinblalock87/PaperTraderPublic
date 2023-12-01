//
//  StockViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import UIKit

class StockViewController: UIViewController {

    @IBOutlet weak var starButton: UIButton!
    var stock: Stock!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = stock.name
        
        var savedStocks = UserDefaults.standard.string(forKey: "watchlist") ?? ""
        var stocksList = savedStocks.components(separatedBy: ",")
        if let index = stocksList.firstIndex(of: stock.symbol) {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
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
    
    @IBAction func starStock(_ sender: Any) {
        var savedStocks = UserDefaults.standard.string(forKey: "watchlist") ?? ""
        var stocksList = savedStocks.components(separatedBy: ",")
        
        if let index = stocksList.firstIndex(of: stock.symbol) {
            UserDefaults.standard.set(stocksList.filter({ $0 != stock.symbol }).joined(separator: ","), forKey: "watchlist")
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            stocksList.append(stock.symbol)
            UserDefaults.standard.set(stocksList.joined(separator: ","), forKey: "watchlist")
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        print(UserDefaults.standard.string(forKey: "watchlist"))
    }
    
}
