//
//  BuySellViewController.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import UIKit

class BuySellViewController: UIViewController {

    var stock = Stock(name: "", symbol: "")
    var action: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let buySellView = attachSwiftUIView(rootView: BuySellView(action: action, stock: stock))
        buySellView.rootView.dismissCallback = {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

}
