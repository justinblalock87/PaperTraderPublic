//
//  ProfileImageView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/7/23.
//

import SwiftUI
import Kingfisher

struct UserChatProfileView: View {

    let profileImageUrl: String?
    let size: CGFloat
    
    init(profileImageUrl: String?, size: CGFloat = 30) {
        self.profileImageUrl = profileImageUrl
        self.size = size
    }
    
    var body: some View {
        KFImage(URL(string: profileImageUrl ?? ""))
            .resizable()
            .placeholder {
                Circle()
                    .foregroundColor(ColorTheme.lightGray)
            }
            .scaledToFill()
            .frame(width: size, height: size, alignment: .top)
            .clipped()
            .cornerRadius(15)
            .padding(.top, 5)
            .padding(.leading, 3)
    }
}
