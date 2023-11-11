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
            Text(paperAccount.name)
                .foregroundStyle(paperAccount.name == activeAccountName ? .green : .black)
        }
    }
}

#Preview {
    PaperAccountListItem(paperAccount: PaperAccount(name: "Test Account", alpacaKey: "", alpacaSecretKey: ""), activeAccountName: "")
}
