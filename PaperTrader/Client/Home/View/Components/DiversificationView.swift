//
//  DiversificationView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/24/23.
//

import Foundation
import SwiftUI

struct DiversificationView: View {
    let difficulty = "beginner"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Diversification in Stocks")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is Diversification?")
                    .font(.headline)
                
                Text("""
                    Diversification is a risk management strategy that mixes a wide variety of investments within a portfolio. The rationale behind this technique contends that a portfolio constructed of different kinds of investments will, on average, yield higher long-term returns and lower the risk of any individual holding or security.
                    """)
                    .font(.body)

                Text("The Importance of Diversification")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("diversification-importance") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Diversification helps in reducing the volatility of your portfolio over time. It is the most common way to manage risk, as it smooths out unsystematic risk events in a portfolio so the positive performance of some investments neutralizes the negative performance of others.
                    """)
                    .font(.body)

                Text("Types of Diversification")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    There are several ways to diversify your investments: across asset classes, within asset classes, and across geographies, sectors, and investment styles.
                    """)
                    .font(.body)
                
                Image("diversification-types")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("Balancing Your Portfolio")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Regularly reviewing and rebalancing your portfolio to align with your investment goals is key. This involves buying or selling assets to maintain your desired level of asset allocation and risk.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(DiversificationTips.allCases, id: \.self) { tip in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            Text(tip.rawValue)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Stock Diversification", displayMode: .inline)
    }
}

enum DiversificationTips: String, CaseIterable {
    case assetClasses = "Diversify across different asset classes."
    case withinAsset = "Diversify within asset classes (e.g., different types of stocks)."
    case geographical = "Consider geographical diversification."
    case sectorDiversification = "Diversify across different sectors and industries."
    case regularRebalancing = "Regularly review and rebalance your portfolio."
}
