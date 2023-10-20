//
//  Auth.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import HTTPTypes
import HTTPTypesFoundation

class AuthManager {
    
    static func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    static func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
        try await signUpAPI(email: email)
    }
    
    static func signUpAPI(email: String) async throws {
        guard let uid = uid() else {
            print("user not logged in")
            return
        }
        var request = HTTPRequest(method: .post, url: URL(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/setup/initialsetup")!)
        let requestBody: [String: Any] = [
            "userId": uid,
            "username": email.substring(to: email.firstIndex(of: "@")!),
            "age": 21
        ]
        let body = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.headerFields[.contentType] = "application/json"
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: body)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return
        }
        print(responseBody)
    }
    
    static func signUpAlpaca(accountName: String, alpacaKey: String, alpacaSecretKey: String) async throws {
        guard let uid = uid() else {
            print("user not logged in")
            return
        }
        var request = HTTPRequest(method: .post, url: URL(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/accounts/create")!)
        let requestBody: [String: Any] = [
            "userId": uid,
            "accountName": accountName,
            "alpacaKey": alpacaKey,
            "alpacaSecretKey": alpacaSecretKey
        ]
        let body = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.headerFields[.contentType] = "application/json"
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: body)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return
        }
        print(responseBody)
    }
    
    static func getPaperAccounts() async throws -> [[String: Any]]? {
        guard let uid = uid() else {
            print("user not logged in")
            return nil
        }
        var components = URLComponents(string: "https://aqueous-caverns-40050-546b6de806d8.herokuapp.com/accounts/get")!
        let parameters = ["userId": uid]
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = HTTPRequest(method: .get, url: components.url!)
        let (responseBody, response) = try await URLSession.shared.data(for: request)
        guard response.status == .ok else {
           // Handle error
           print("response error", response)
           return nil
        }
        return JSON.dataToDict(data: responseBody)["paperAccounts"] as? [[String:Any]]
    }
    
    static func uid() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
