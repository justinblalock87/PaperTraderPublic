//
//  HomeView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import SwiftUI
import ExytePopupView

struct HomeView: View {
    
    @StateObject var vm = HomeViewModel()
    @StateObject var portfolioVM = PortfolioViewModel()
    @StateObject var infoVM = InfoViewModel()
    
    @State var loadingAccounts = true
    @State var needsPaperAccount = false
    @State var accountName: String = "Paper"
    @State var alpacaKey: String = "PK1Y8KLXJ30IK23SNTUS"
    @State var alpacaSecretKey: String = "dT0Jnh2VvTWRjjoQVcn179QsPOalgruq4FSKVqXv"
    
    @State var searchText = ""
    @State var showAds = true
    @State var returnedStocks: [Stock]?
    
    @State var showInfoPopup = false
    
    var segueStock: ((Stock) -> Void)?
    var segueSettings: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            ZStack {
                DarkColorTheme.darkBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    if !searchText.isEmpty {
                        // User is searching
                        searchFilterStocks
                    } else {
                        VStack(alignment: .leading) {
                            if loadingAccounts {
                                LoadingIndicator()
                            } else if needsPaperAccount {
                                createPaperAccountView
                                    .padding()
                                    .cornerRadius(20)
                            } else {
                                WatchList(vm: vm, segueStock: segueStock)
                                    .padding(.top, 20)
                                    .padding(.bottom, 40)
                                TopMovers(vm: vm, segueStock: segueStock)
                                    .padding(.bottom, 40)
                                
                                Text("Assets")
                                    .font(.system(size: 30, weight: .semibold, design: .default))
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 20)
                                ForEach(Array(vm.stocks.enumerated()), id: \.1.symbol) { (i, stock) in
                                    Button(action: {
                                        segueStock?(stock)
                                    }, label: {
                                        StockListItem(stock: stock)
                                    })
                                    Divider()
                                    if i % 10 == 0 && showAds {
                                        BannerView()
                                            .frame(height: 75)
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .task {
                            let accounts = await checkForPaperAccount()
                            loadingAccounts = false
                            if accounts.count > 0 {
                                needsPaperAccount = false
                            }
                            print(RemoteConfigListener.shared.remoteConfig["showads"].stringValue, RemoteConfigListener.shared.remoteConfig["ad_type"].stringValue)
                            showAds = (RemoteConfigListener.shared.remoteConfig["showads"].stringValue ?? "") == "true" && ((RemoteConfigListener.shared.remoteConfig["ad_type"].stringValue ?? "") == "native" || (RemoteConfigListener.shared.remoteConfig["ad_type"].stringValue ?? "") == "both")
                            try? await vm.fetchStockList()
                            try? await vm.getTopMovers()
                        }
                    }
                    
                }
                
            }
            .analyticsScreen(name: "Home")
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(infoVM)
            .popup(isPresented: $infoVM.shouldShowInfo) {
                InfoPopupView(infoText: infoVM.infoText, infoLink: infoVM.infoLink)
            } customize: {
                $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.4))
                .isOpaque(true)
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            Task.init {
                returnedStocks = try? await vm.searchForStock(symbol: searchText)
            }
        }
    }
    
    private var header: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(ColorTheme.darkerLightGray)
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .cornerRadius(35)
                    .clipped()
                    .onTapGesture {
                        segueSettings?()
                    }
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Stocks")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(Color.white)
                    Text("\(Date().monthDay() ?? "")")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(DarkColorTheme.lightGray)
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
    
    private var searchFilterStocks: some View {
        VStack {
            if let stocks = returnedStocks {
                ForEach(Array(stocks.enumerated()), id: \.1.symbol) { (i, stock) in
                    Button(action: {
                        segueStock?(stock)
                    }, label: {
                        StockListItem(stock: stock)
                    })
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var createPaperAccountView: some View {
        VStack(spacing: 20) {
            Text("Add in your Alpaca paper account info to continue")
                .multilineTextAlignment(.center)
                .font(.headline)
                .foregroundStyle(Color.white)
            TextField("Account Name", text: $accountName)
                .padding()
                .background(DarkColorTheme.lightGray)
                .cornerRadius(10)
            TextField("Alpaca Key", text: $alpacaKey)
                .padding()
                .background(DarkColorTheme.lightGray)
                .cornerRadius(10)
            TextField("Alpaca Secret Key", text: $alpacaSecretKey)
                .padding()
                .background(DarkColorTheme.lightGray)
                .cornerRadius(10)
            Button(action: {
                Task.init {
                    do {
                        let accounts = try await createPaperAccount()
                        if accounts.count > 0 {
                            needsPaperAccount = false
                        }
                    } catch {
                        print("error creating alpaca account", error)
                    }
                }
            }) {
                Text("Create Alpaca Account")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .background(DarkColorTheme.darkGray)
        .navigationBarBackButtonHidden(false)
    }
    
    func checkForPaperAccount() async -> [PaperAccount] {
        return (try? await AuthManager.getPaperAccounts()) ?? []
    }
    
    func createPaperAccount() async throws -> [PaperAccount] {
        try await AuthManager.signUpAlpaca(accountName: accountName, alpacaKey: alpacaKey, alpacaSecretKey: alpacaSecretKey)
        return try await AuthManager.getPaperAccounts()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



