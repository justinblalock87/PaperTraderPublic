//
//  BuySellView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import SwiftUI
import FirebaseAnalytics

struct BuySellView: View {
    
    @State private var quantity = "0"
    @State var hasTriedAd = false
    @State var showConfirmation = false
    @State var showAds = true
    
    let action: String
    let stock: Stock
    private let coordinator = InterstitialAdCoordinator()
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    
    var dismissCallback: (() -> Void)?
    
    var body: some View {
        ZStack {
            DarkColorTheme.darkBackground
                .ignoresSafeArea()
            VStack(spacing: 0) {
                header
                numpad
                confirmButton
                    .padding(.vertical, 20)
            }
        }
        .background(adViewControllerRepresentableView)
        .onAppear(perform: {
            Task.init {
                do {
                    try await coordinator.loadAd()
                } catch {
                    hasTriedAd = true
                    print("error loading ad ", String(String(describing: error)))
                }
            }
            showAds = (RemoteConfigListener.shared.remoteConfig["showads"].stringValue ?? "") == "true" && ((RemoteConfigListener.shared.remoteConfig["ad_type"].stringValue ?? "") == "inter" || (RemoteConfigListener.shared.remoteConfig["ad_type"].stringValue ?? "") == "both")
        })
        .alert(isPresented: $showConfirmation, content: {
            Alert(title: Text("Order placed!"), message: nil, dismissButton: .default(Text("Done"), action: {
                if !hasTriedAd && showAds {
                    hasTriedAd = true
                    coordinator.showAd(from: adViewControllerRepresentable.viewController)
                } else {
                    dismissCallback?()
                }
            }))
        })
        .analyticsScreen(name: "buy/sell", extraParameters: ["type": action])
    }
    
    var adViewControllerRepresentableView: some View {
      adViewControllerRepresentable
        .frame(width: .zero, height: .zero)
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
                Text(action.capitalized + " units")
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
            Button(action: {
                Analytics.logEvent("confirm_clicked", parameters: nil)
                Task.init {
                    try? await trade()
                }
            }, label: {
                Text("Confirm Order")
                    .foregroundStyle(ColorTheme.primaryColor)
                    .font(.system(size: 18, weight: .semibold))
            })
        }
    }
    
    private func trade() async throws {
        if action == "buy" {
            try await StockManager.buyStock(stock: stock, quantity: Int(quantity) ?? 0)
            showConfirmation = true
        } else if action == "sell" {
            try await StockManager.sellStock(stock: stock, quantity: Int(quantity) ?? 0)
            showConfirmation = true
        }
        
    }
}

#Preview {
    BuySellView(action: "buy", stock: Stock(name: "Apple", symbol: "AAPL", price: 20, percentageChange: 20))
}
