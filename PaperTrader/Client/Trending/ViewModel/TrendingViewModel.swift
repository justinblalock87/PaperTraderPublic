//
//  TrendingViewModel.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import Foundation

class TrendingViewModel: ObservableObject {
    
    @Published var topComments: [Comment] = []
    
    func fetchTopComments() async throws {
        let topComments = try await SocialManager.getTopComments()
        DispatchQueue.main.async {
            self.topComments = topComments
        }
    }
}
