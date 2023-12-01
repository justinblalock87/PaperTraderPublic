//
//  SignInView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import SwiftUI
import SpriteKit
import Foundation
import HTTPTypes
import HTTPTypesFoundation
import FirebaseAuth

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var failedSignIn: Bool = false
    
    var signInCallback: (() -> Void)?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, ColorTheme.darkGray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Paper Trader")
                    .font(.system(size: 50, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .submitLabel(.done)
                    Button(action: {
                        Task.init {
                            do {
                                try await signIn()
                            } catch {
                                failedSignIn = true
                            }
                        }
                    }) {
                        Text("Sign in")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        Task.init {
                            do {
                                try await signUp()
                            } catch {
                                failedSignIn = true
                            }
                        }
                    }) {
                        Text("Sign up")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    if failedSignIn {
                        Text("Sign-in failed, please try again.")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(20)
            }
            .padding()
        }
        .analyticsScreen(name: "Signin")
        .ignoresSafeArea()
    }
    
    func signIn() async throws {
        try await AuthManager.signIn(email: email, password: password)
    }
    
    func signUp() async throws {
        try await AuthManager.signUp(email: email, password: password)
    }
}

#Preview {
    SignInView()
}
