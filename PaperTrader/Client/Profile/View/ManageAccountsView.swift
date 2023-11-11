//
//  ManageAccountsView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import SwiftUI

struct ManageAccountsView: View {
    
    @State var currentUser: User?
    @State var accountName: String = "Paper"
    @State var alpacaKey: String = "PK1Y8KLXJ30IK23SNTUS"
    @State var alpacaSecretKey: String = "dT0Jnh2VvTWRjjoQVcn179QsPOalgruq4FSKVqXv"
    
    var dismissCallback: (() -> Void)?
    @State var accounts: [PaperAccount] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                header
                createPaperAccountView
                accountsList
            }
            .padding(.horizontal, 10)
            .task(priority: .userInitiated, {
                currentUser = try? await UserManager.getCurrentUser()
            })
        }
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
                Text("Paper Accounts")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
            }
            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.025)
            Divider()
        }
        .padding(.bottom, 20)
    }
    
    private var createPaperAccountView: some View {
        VStack(spacing: 20) {
            Text("Add Alpaca Paper Account")
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
    
    private var accountsList: some View {
        VStack {
            ForEach(accounts) { account in
                PaperAccountListItem(paperAccount: account, activeAccountName: currentUser?.activePaperAccount ?? "")
                    .onTapGesture {
                        Task.init {
                            await activateAccount(accountName: account.name)
                        }
                    }
            }
        }
        .task {
            let accounts = try? await AuthManager.getPaperAccounts()
            if let accounts = accounts {
                self.accounts = accounts
            }
        }
    }
    
    func createPaperAccount() async throws -> [PaperAccount] {
        try await AuthManager.signUpAlpaca(accountName: accountName, alpacaKey: alpacaKey, alpacaSecretKey: alpacaSecretKey)
        return try await AuthManager.getPaperAccounts()
    }
    
    func activateAccount(accountName: String) async {
        do {
            try await UserManager.setPaperAccount(accountName: accountName)
            await reloadAccount()
        } catch {
            print("error setting paper account", String(describing: error))
        }
    }
    
    func reloadAccount() async {
        currentUser = try? await UserManager.getCurrentUser()
    }
}

#Preview {
    ManageAccountsView()
}
