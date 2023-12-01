//
//  LongTermInvestingView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/24/23.
//

import Foundation
import SwiftUI

struct LongTermInvestingView: View {
    let difficulty = "beginner"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Long-Term Investing Strategies")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is Long-Term Investing?")
                    .font(.headline)
                
                Text("""
                    Long-term investing involves holding onto stocks or other assets for an extended period, typically years or even decades. This strategy focuses on the gradual growth and compounding of investments over time, rather than short-term fluctuations.
                    """)
                    .font(.body)

                Text("Benefits of Long-Term Investing")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("long-term-benefits")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Long-term investing offers several benefits, including reduced impact of short-term volatility, potential for significant compounding effects, and generally lower tax implications compared to frequent trading.
                    """)
                    .font(.body)

                Text("Diversification")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Diversification is key in long-term investing. It involves spreading investments across various sectors and asset classes to reduce risk and improve the potential for steady growth.
                    """)
                    .font(.body)
                
                Text("Investing in Value Stocks")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("long-term-value") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Value investing is a strategy where investors look for stocks that appear to be undervalued in the market. It's about finding diamonds in the rough and holding onto them for long-term gains.
                    """)
                    .font(.body)

                Text("The Power of Compounding")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Compounding can significantly increase the value of investments over time. Reinvesting dividends and holding onto appreciating assets can lead to exponential growth in the long run.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(LongTermInvestingTips.allCases, id: \.self) { tip in
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
        .navigationBarTitle("Long-Term Investing", displayMode: .inline)
    }
}

enum LongTermInvestingTips: String, CaseIterable {
    case patienceIsKey = "Be patient and focus on long-term growth."
    case diversifyInvestments = "Diversify your portfolio across different sectors."
    case valueInvesting = "Look for undervalued stocks with long-term potential."
    case reinvestDividends = "Reinvest dividends for compounding growth."
    case avoidTimingMarket = "Avoid trying to time the market."
}

