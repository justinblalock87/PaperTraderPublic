//
//  HomeView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = HomeViewModel()
    
    @State var loadingAccounts = true
    @State var needsPaperAccount = true
    @State var accountName: String = "Paper"
    @State var alpacaKey: String = "PK1Y8KLXJ30IK23SNTUS"
    @State var alpacaSecretKey: String = "dT0Jnh2VvTWRjjoQVcn179QsPOalgruq4FSKVqXv"
    var segueStock: ((Stock) -> Void)?
    
    var body: some View {
        ZStack {
            VStack {
                if loadingAccounts {
                    LoadingIndicator()
                } else if needsPaperAccount {
                    createPaperAccountView
                        .padding()
                        .cornerRadius(20)
                } else {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Stocks")
                                .font(.system(size: 30, weight: .black))
                            Text("\(Date().monthDay() ?? "")")
                                .font(.system(size: 30, weight: .black))
                                .foregroundStyle(ColorTheme.darkGray)
                        }
                         Spacer()
                    }
                    LazyVStack(spacing: 15) {
                        ForEach(vm.stocks, id: \.symbol) { stock in
                            Button(action: {
                                segueStock?(stock)
                            }, label: {
                                StockListItem(stock: stock)
                            })
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal)
            .task {
                let accounts = await checkForPaperAccount()
                loadingAccounts = false
                if accounts?.count ?? 0 > 0 {
                    needsPaperAccount = false
                }
            }
        }
    }
    
    private var createPaperAccountView: some View {
        VStack(spacing: 20) {
            Text("Add in your Alpaca paper account info to continue")
                .multilineTextAlignment(.center)
                .font(.headline)
            TextField("Account Name", text: $accountName)
                .padding()
                .background(ColorTheme.lightGray)
                .cornerRadius(10)
            TextField("Alpaca Key", text: $alpacaKey)
                .padding()
                .background(ColorTheme.lightGray)
                .cornerRadius(10)
            TextField("Alpaca Secret Key", text: $alpacaSecretKey)
                .padding()
                .background(ColorTheme.lightGray)
                .cornerRadius(10)
            Button(action: {
                Task.init {
                    do {
                        let accounts = try await createPaperAccount()
                        if accounts?.count ?? 0 > 0 {
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
    }
    
    func checkForPaperAccount() async -> [[String: Any]]? {
        return try! await AuthManager.getPaperAccounts()
    }
    
    func createPaperAccount() async throws -> [[String: Any]]? {
        try await AuthManager.signUpAlpaca(accountName: accountName, alpacaKey: alpacaKey, alpacaSecretKey: alpacaSecretKey)
        return try await AuthManager.getPaperAccounts()
    }
}

#Preview {
    HomeView()
}
