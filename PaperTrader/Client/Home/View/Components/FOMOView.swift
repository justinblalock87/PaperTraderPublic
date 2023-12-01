//
//  FOMOView.swift
//  PaperTrader
//
//  Created by Leul Wubete on 11/24/23.
//

import Foundation
import SwiftUI

struct FOMOView: View {
    let difficulty = "beginner"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Navigating FOMO in Trading")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is FOMO?")
                    .font(.headline)
                
                Text("""
                    FOMO, or Fear Of Missing Out, refers to the anxiety traders feel when they believe they are missing out on a potentially profitable market opportunity. It often leads to impulsive decisions, such as entering trades without proper analysis or risk management.
                    """)
                    .font(.body)

                Text("The Impact of FOMO")
                    .font(.headline)
                    .padding(.top, 10)
                
                Image("fomo-impact") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("""
                    FOMO can lead to overtrading, chasing performance, ignoring risk management strategies, and ultimately, significant losses. It's driven by emotional trading rather than rational decision-making.
                    """)
                    .font(.body)

                Text("Managing FOMO")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    Managing FOMO involves developing a disciplined trading strategy, sticking to your risk management rules, and accepting that missing out is better than making unwise decisions. It's crucial to focus on long-term goals rather than short-term gains.
                    """)
                    .font(.body)
                
                Image("fomo-management") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200) // Adjust the size as needed
                    .padding(.top, 10)

                Text("Strategies to Overcome FOMO")
                    .font(.headline)
                    .padding(.top, 10)

                Text("""
                    To overcome FOMO, traders should focus on their own trading plans, avoid constantly checking the market, and learn to recognize the signs of FOMO in their behavior. Educating oneself about market cycles and volatility can also be beneficial.
                    """)
                    .font(.body)

                Text("Key Points")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(FOMOTips.allCases, id: \.self) { tip in
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
        .navigationBarTitle("FOMO in Trading", displayMode: .inline)
    }
}

enum FOMOTips: String, CaseIterable {
    case stickToPlan = "Stick to your trading plan and avoid impulsive decisions."
    case riskAwareness = "Always be aware of the risks involved in trading."
    case avoidHerdMentality = "Don't follow the herd; make informed decisions."
    case longTermFocus = "Focus on long-term goals, not short-term gains."
    case marketEducation = "Educate yourself about market cycles and volatility."
    case emotionalAwareness = "Be aware of your emotions and how they affect your trading."
}
