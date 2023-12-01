//
//  PaperAccountListItem.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/5/23.
//

import SwiftUI

struct PaperAccountListItem: View {
    
    let paperAccount: PaperAccount
    let activeAccountName: String
    
    var body: some View {
        VStack {
            HStack {
                Text(paperAccount.name)
                    .foregroundStyle(paperAccount.name == activeAccountName ? .green : .black)
                    .font(.system(size: 18, weight: .medium))
                if paperAccount.name == activeAccountName {
                    Text("• Active")
                        .font(.system(size: 18, weight: .medium))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    PaperAccountListItem(paperAccount: PaperAccount(name: "Test Account", alpacaKey: "", alpacaSecretKey: ""), activeAccountName: "")
}
