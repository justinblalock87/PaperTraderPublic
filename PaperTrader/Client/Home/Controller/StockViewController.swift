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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
