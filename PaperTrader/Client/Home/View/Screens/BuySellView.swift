//
//  BuySellView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import SwiftUI
import FirebaseAnalytics

var educationalContents = ["Buying stocks means you are purchasing a share of the company. When the company's value goes up, so does the value of your stock.", "Selling stocks means you are selling your share of the company. It's usually done when you believe the value might go down or to realize a profit."]
struct BuySellView: View {
    
    @State private var quantity = "0"
    @State private var showEducationalPopup = false
    let action: String
    let stock: Stock
    
    var dismissCallback: (() -> Void)?
    
    var body: some View {
        ZStack {
            DarkColorTheme.darkBackground
                .ignoresSafeArea()
            VStack(spacing: 40) {
                header
                numpad
                confirmButton
            }
        }
        .alert(isPresented: $showEducationalPopup, content: {
            Alert(title: Text("Learn"), message: Text(educationalContents.randomElement() ?? educationalContents[0]), dismissButton: .cancel(Text("Got it!")))
        })
        .onAppear(perform: {
            showEducationalPopup = true
        })
        .analyticsScreen(name: "buy/sell", extraParameters: ["type": action])
    }
    
    private var header: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        dismissCallback?()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .buttonStyle(.plain)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding()
                    Spacer()
                }
                Text(action.capitalized)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.025)
            Divider()
        }
        .padding(.bottom, 20)
    }
    
    private var numpad: some View {
        VStack {
            HStack {
                Spacer()
                Text(quantity)
                    .foregroundStyle(Color.white)
            }.padding([.leading, .trailing])
            Divider()
            KeyPad(string: $quantity)
        }
        .font(.largeTitle)
            .padding()
    }
    
    private var confirmButton: some View {
        VStack {
            Button("Confirm Order") {
                Analytics.logEvent("confirm_clicked", parameters: nil)
                Task.init {
                    try? await trade()
                }
            }
        }
    }
    
    private func trade() async throws {
        if action == "buy" {
            try await StockManager.buyStock(stock: stock, quantity: Int(quantity) ?? 0)
            dismissCallback?()
        } else if action == "sell" {
            try await StockManager.sellStock(stock: stock, quantity: Int(quantity) ?? 0)
            dismissCallback?()
        }
        
    }
}

#Preview {
    BuySellView(action: "buy", stock: Stock(name: "Apple", symbol: "AAPL", price: 20, percentageChange: 20))
}
