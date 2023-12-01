//
//  TrendTradingView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/8/23.
//

import Foundation
import SwiftUI

struct TrendTradingView: View {
    let difficulty = "advanced"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Trend Trading 101")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is Trend Trading?")
                    .font(.headline)
                
                Text("""
                    Trend trading is a strategy that involves analyzing the momentum of stocks to make buy and sell decisions. It's based on the idea that stocks which are moving upwards or downwards will continue to move in that direction.
                    """)
                    .font(.body)

                Text("Identifying Trends")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("trend-dir")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    The key to trend trading is identifying and following the stock's trend. This can be done by looking at stock charts and using technical analysis tools like moving averages, trendlines, and price action.
                    """)
                    .font(.body)

                Text("Entry and Exit Points")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Successful trend traders know when to enter and exit the market. They enter a trade when a trend is established and exit when the trend shows signs of reversing. Setting stop-loss orders is crucial to minimize potential losses.
                    """)
                    .font(.body)
                
                Image("entry-exit") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("Patience is Key")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Trend trading requires patience, as trends can develop over longer periods. It's important not to react hastily to short-term market fluctuations and to stick to your trading plan.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(TrendTradingTips.allCases, id: \.self) { tip in
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
        .navigationBarTitle("Trend Trading", displayMode: .inline)
    }
}

enum TrendTradingTips: String, CaseIterable {
    case identifyTrends = "Identify trends using technical analysis."
    case patience = "Be patient and wait for clear trends to form."
    case riskManagement = "Implement strong risk management strategies."
    case exitStrategy = "Have a clear exit strategy for each trade."
    case avoidPredicting = "Avoid predicting market movements; react to them instead."
}
