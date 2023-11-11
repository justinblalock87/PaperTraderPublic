//
//  HomeView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = HomeViewModel()
    @StateObject var portfolioVM = PortfolioViewModel()
    
    @State var loadingAccounts = true
    @State var needsPaperAccount = false
    @State var accountName: String = "Paper"
    @State var alpacaKey: String = "PK1Y8KLXJ30IK23SNTUS"
    @State var alpacaSecretKey: String = "dT0Jnh2VvTWRjjoQVcn179QsPOalgruq4FSKVqXv"
    var segueStock: ((Stock) -> Void)?
    var segueSettings: (() -> Void)?
    @State var showAds = true
    
    var body: some View {
        ZStack {
            DarkColorTheme.darkBackground
                .ignoresSafeArea()
                
            ScrollView {
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
                    
                    PortfolioChartView(viewModel: portfolioVM)
                        .frame(height: 200)
                        .padding(.bottom, 40)
                        .onAppear {
                            portfolioVM.reload()
                        }
                    
                    if loadingAccounts {
                        LoadingIndicator()
                    } else if needsPaperAccount {
                        createPaperAccountView
                            .padding()
                            .cornerRadius(20)
                    } else {
                        LazyVStack(spacing: 15) {
                            ForEach(Array(vm.stocks.enumerated()), id: \.1.symbol) { (i, stock) in
                                Button(action: {
                                    segueStock?(stock)
                                }, label: {
                                    StockListItem(stock: stock)
                                })
                                Divider()
                                if i % 5 == 0 && showAds {
                                    VStack {
                                        Text("Example Ad Placement")
                                            .foregroundStyle(.white)
                                            .padding(.vertical, 20)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .background(Color.gray)
                                    Divider()
                                }
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
                    print(RemoteConfigListener.shared.remoteConfig["ads_enabled"].stringValue)
                    showAds = (RemoteConfigListener.shared.remoteConfig["ads_enabled"].stringValue ?? "") == "true"
                }
            }
        }
        .analyticsScreen(name: "Home")
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

struct DarkColorTheme {
    static let darkBackground = Color.black
    static let darkGray = Color(white: 0.2)
    static let lightGray = Color(white: 0.6)
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


