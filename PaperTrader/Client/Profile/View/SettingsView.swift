//
//  SettingsView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/4/23.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    var body: some View {
        ZStack {
            DarkColorTheme.darkBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    header
                    helpSettings
                    footer
                }
            }
        }
    }
    
    private var header: some View {
        VStack {
            ZStack {
                Text("Settings")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.025)
            Divider()
        }
        .padding(.bottom, 20)
    }
    
    private var helpSettings: some View {
        VStack {
            HStack {
                Text("Help / Feedback")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(ColorTheme.darkGray)
                Spacer()
            }
            .padding(.horizontal)
            Divider()
                .foregroundStyle(.white)
            VStack {
                HStack(spacing: 20) {
                    HStack {
                        Text("Contact Us")
                            .font(CustomFonts.sfProSubtitle)
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .onTapGesture {
                let mailto = "mailto:".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let url = URL(string: mailto!) {
//                    openURL(url)
                }
            }
            Divider()
                .foregroundStyle(.white)
        }
    }
    
    private var footer: some View {
        VStack {
            VStack {
                Divider()
                Button(action: {
                    signOut()
                }) {
                    HStack {
                        Spacer()
                        Text("Logout")
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                .padding(10)
                Divider()
            }
            .padding(.bottom, 10)
            VStack {
                Text("Version 0.0.1")
                    .foregroundStyle(.white)
            }
            .font(CustomFonts.sfProFootnote)
            .foregroundColor(.white)
        }
    }
    
    private func signOut() {
        try! Auth.auth().signOut()
    }
}

#Preview {
    SettingsView()
}
