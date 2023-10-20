//
//  CommentView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import SwiftUI

struct CommentView: View {
    
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(comment.timestamp.getDate().timeAgoDisplay())
                    .font(.system(size: 14))
                    .foregroundStyle(ColorTheme.darkGray)
                Text("\(comment.authorUsername): \(comment.content)")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

//#Preview {
//    CommentView()
//}
