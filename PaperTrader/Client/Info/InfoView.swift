//
//  InfoView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/24/23.
//

import SwiftUI
import ExytePopupView

class InfoViewModel: ObservableObject {
    @Published var shouldShowInfo = false
    
    var infoText = ""
    var infoLink: String? = nil
}

struct InfoView: View {
    
    @EnvironmentObject var infoVM: InfoViewModel
    
    let infoText: String
    let infoLink: String?
    
    init(infoText: String, infoLink: String? = nil) {
        self.infoText = infoText
        self.infoLink = infoLink
    }
    
    var body: some View {
        Button(action: {
            infoVM.infoText = infoText
            infoVM.infoLink = infoLink
            infoVM.shouldShowInfo = true
        }, label: {
            Image(systemName: "info.circle")
        })
    }
}

struct InfoPopupView: View {

    @State private var showingAlert = false
    @State private var feedback = ""
    
    let infoText: String
    let infoLink: String?
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "graduationcap.circle")
                .padding(.vertical, 20)
                .frame(width: 50, height: 50)
            Text(infoText)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .opacity(0.6)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
            
            HStack {
                Spacer()
                
                Button("Feedback") {
                    showingAlert.toggle()
                }
                .alert("Enter your feedback", isPresented: $showingAlert) {
                    TextField("Feedback...", text: $feedback)
                    Button("Done", action: submitFeedback)
                }
                .padding()
                .foregroundStyle(ColorTheme.primaryColor)
                .font(.system(size: 14))
            }
        }
        .frame(maxWidth: .infinity)
        .background(DarkColorTheme.darkPopup.cornerRadius(20))
    }
    
    func submitFeedback() {
        Task.init {
            try? await StockManager.submitFeedback(text: feedback)
        }
    }
}
