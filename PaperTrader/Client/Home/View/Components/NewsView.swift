//
//  NewsView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/7/23.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("In the News")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            Text("Apple is blaming a software bug and other issues tied to popular apps such as Instagram and Uber for causing its recently released iPhone 15 models to heat up and spark complaints about becoming too hot to handle. The Cupertino, California, company said Saturday that it is working on an update to the iOS17 system that powers the iPhone 15 lineup to prevent the devices from becoming uncomfortably hot and is working with apps that are running in ways “causing them to overload the system.” Instagram, owned by Meta Platforms, modified its social media app earlier this week to prevent it from heating up the device on the latest iPhone operating system. Uber and other apps such as the video game Asphalt 9 are still in the process of rolling out their updates, Apple said. It didn’t specify a timeline for when its own software fix would be issued but said no safety issues should prevent iPhone 15 owners from using their devices while awaiting the update.")
        }
    }
}

#Preview {
    NewsView()
}
