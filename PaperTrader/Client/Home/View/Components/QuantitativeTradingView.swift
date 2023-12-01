//
//  QuantitativeTradingView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/24/23.
//

import Foundation
import SwiftUI

struct QuantitativeTradingView: View {
    let difficulty = "advanced"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Quantitative Trading Strategies")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is Quantitative Trading?")
                    .font(.headline)
                
                Text("""
                    Quantitative trading involves using mathematical models and algorithms to identify trading opportunities. It's a data-driven approach that relies heavily on historical data and statistical analysis to predict market movements and make trading decisions.
                    """)
                    .font(.body)

                Text("Top Performing Strategies")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("quant-strategies")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Some top-performing quantitative strategies include Mean Reversion, Momentum, Statistical Arbitrage, and Machine Learning-based approaches. These strategies are often automated and executed using complex algorithms.
                    """)
                    .font(.body)

                Text("Mean Reversion")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Mean Reversion is based on the idea that prices and returns eventually move back towards the mean or average. This strategy involves buying undervalued stocks and selling overvalued ones.
                    """)
                    .font(.body)
                
                Text("Momentum Trading")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Momentum trading strategies involve following market trends. Stocks that are trending upwards are bought, and those trending downwards are sold, with the expectation that the trend will continue.
                    """)
                    .font(.body)

                Text("Statistical Arbitrage")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    This strategy uses statistical models to identify short-term trading opportunities, exploiting price differences between correlated assets or mispriced securities.
                    """)
                    .font(.body)

                Text("Machine Learning in Trading")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("machine-learning")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Machine Learning algorithms can analyze vast amounts of data to identify patterns and predict market movements, offering a more dynamic approach to quantitative trading.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(QuantitativeTradingTips.allCases, id: \.self) { tip in
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
        .navigationBarTitle("Quantitative Trading", displayMode: .inline)
    }
}

enum QuantitativeTradingTips: String, CaseIterable {
    case dataDriven = "Rely on data and statistical analysis for decision-making."
    case algorithmicApproach = "Use algorithms for automated trading."
    case riskManagement = "Implement strong risk management strategies."
    case continuousLearning = "Continuously update and refine your models."
    case adaptability = "Be adaptable to market changes and new data."
}
