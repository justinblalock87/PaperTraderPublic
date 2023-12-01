//
//  StopLossView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/24/23.
//

import Foundation
import SwiftUI

struct StopLossView: View {
    let difficulty = "advanced"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Understanding Stop Loss")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is a Stop Loss?")
                    .font(.headline)
                
                Text("""
                    A stop loss is an order placed with a broker to buy or sell once the stock reaches a certain price. A stop loss is designed to limit an investor's loss on a security position. Setting a stop loss is especially important in volatile markets, helping to cap potential losses.
                    """)
                    .font(.body)

                Text("The Importance of Stop Loss")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("stop-loss-importance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) 
                    .padding(.top, 10)

                Text("""
                    Using a stop loss can take some of the emotion out of trading decisions, as it automatically executes trades when certain criteria are met. It's a useful tool for preserving capital and managing risk effectively.
                    """)
                    .font(.body)

                Text("Setting a Stop Loss")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    When setting a stop loss, you can choose a fixed amount of risk or a percentage of your current portfolio value. It's important to set stop losses at a level that gives the market enough room to fluctuate while protecting you from too much loss.
                    """)
                    .font(.body)
                
                Image("stop-loss-setting")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .padding(.top, 10)

                Text("Stop Loss Strategies")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    There are different strategies for setting stop losses, like the percentage stop loss, volatility stop, and time stop. Understanding these strategies can help you make more informed decisions about risk management.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(StopLossTips.allCases, id: \.self) { tip in
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
        .navigationBarTitle("Stop Loss Strategies", displayMode: .inline)
    }
}

enum StopLossTips: String, CaseIterable {
    case emotionControl = "Use stop loss to control emotions in trading."
    case riskManagement = "Effective for risk management and capital preservation."
    case settingStrategy = "Choose the right strategy for setting stop losses."
    case percentageBased = "Consider percentage-based stop losses for consistency."
    case volatilityAware = "Be aware of market volatility when setting stop losses."
    case reviewRegularly = "Regularly review and adjust your stop loss orders."
}

