//
//  EventDrivenTradingView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/24/23.
//

import Foundation
import SwiftUI

struct EventDrivenTradingView: View {
    let difficulty = "advanced"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Event-Driven Trading Strategies")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is Event-Driven Trading?")
                    .font(.headline)
                
                Text("""
                    Event-driven trading is a strategy that focuses on capitalizing on stock price movements caused by significant events such as earnings reports, mergers, acquisitions, or political changes. This approach requires staying informed and reacting quickly to news.
                    """)
                    .font(.body)

                Text("The Role of Bots in Event-Driven Trading")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("event-driven-bots") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Using bots can be a game-changer in event-driven trading. Bots can quickly analyze news and company announcements, allowing traders to enter and exit trades in a timely manner, capitalizing on the volatility these events create.
                    """)
                    .font(.body)

                Text("Key Strategies in Event-Driven Trading")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("event-driven-topics") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    Successful event-driven trading involves identifying potential market-moving events, understanding the likely impact on stock prices, and having a clear plan for entry and exit points. It's crucial to be well-informed and responsive.
                    """)
                    .font(.body)

                Text("Risks and Rewards")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    While event-driven trading can offer significant profit opportunities due to high market volatility, it also comes with increased risks. Quick market changes can lead to both rapid gains and losses.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(EventDrivenTradingTips.allCases, id: \.self) { tip in
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
        .navigationBarTitle("Event-Driven Trading", displayMode: .inline)
    }
}

enum EventDrivenTradingTips: String, CaseIterable {
    case stayInformed = "Stay informed about market-moving events."
    case useBots = "Utilize bots for quick analysis and trade execution."
    case planYourTrades = "Have a clear plan for entry and exit points."
    case understandImpact = "Understand the potential impact of events on stock prices."
    case manageRisk = "Be prepared for high volatility and manage risk accordingly."
}
