//
//  CommentView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import SwiftUI

struct CommentView: View {
    
    var comment: Comment
    @State private var didLike: Bool = false
    @State private var didDislike: Bool = false

    init(comment: Comment) {
        self.comment = comment

        if let uid = AuthManager.uid() {
            if comment.likers.contains(uid) {
                self._didLike = State(initialValue: true)
            } else if comment.dislikers.contains(uid) {
                self._didDislike = State(initialValue: true)
            }
        }
    }
        var body: some View {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    UserChatProfileView(profileImageUrl: "")
                    
                    Text("@\(comment.authorUsername) (\(comment.authorReliability))")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text(comment.timestamp.getDate().timeAgoDisplay())
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Text(comment.content)
                    .padding(.vertical, 4)
                HStack {
                    Button(action: {
                        self.didLike.toggle()
                        if self.didLike {
                            Task.init {
                                try? await self.likeComment()
                            }
                            self.comment.likes += 1
                            if self.didDislike {
                                self.comment.likes += 1
                                self.didDislike = false
                            }
                        } else {
                            self.comment.likes -= 1
                            Task.init {
                                try? await self.removeLike()
                            }
                        }
                    }) {
                        Image(systemName: didLike ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(didLike ? .blue : .gray)
                        Text("\(comment.likes)")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .scaleEffect(didLike ? 1.2 : 1)
                    .animation(.easeInOut, value: didLike)

                    Button(action: {
                        self.didDislike.toggle()
                        if self.didDislike {
                            Task.init {
                                try? await self.dislikeComment()
                            }
                            self.comment.likes -= 1
                            if self.didLike {
                                self.comment.likes -= 1
                                self.didLike = false
                            }
                        } else {
                            self.comment.likes += 1
                            Task.init {
                                try? await self.removeDislike()
                            }
                        }
                    }) {
                        Image(systemName: didDislike ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(didDislike ? .red : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .scaleEffect(didDislike ? 1.2 : 1)
                    .animation(.easeInOut, value: didDislike)
                }
                .font(.system(size: 14))
            }
            .padding(.vertical, 5)
        }
    
    func likeComment() async throws {
        try await StockManager.likeComment(comment: comment, like: true, remove: false)
    }
    
    func removeLike() async throws {
        try await StockManager.likeComment(comment: comment, like: true, remove: true)
    }
    
    func dislikeComment() async throws {
        try await StockManager.likeComment(comment: comment, like: false, remove: false)
    }
    
    func removeDislike() async throws {
        try await StockManager.likeComment(comment: comment, like: false, remove: true)
    }
}

#Preview {
    VStack {
        CommentView(comment: Comment(id: "1", authorID: "1", authorUsername: "justin", timestamp: 100000, content: "This is a test comment", authorReliability: 0, likes: 1, likers: [], dislikers: []))
        CommentView(comment: Comment(id: "1", authorID: "1", authorUsername: "justin", timestamp: 100000, content: "This is a test comment", authorReliability: 0, likes: 1, likers: [], dislikers: []))
        CommentView(comment: Comment(id: "1", authorID: "1", authorUsername: "justin", timestamp: 100000, content: "This is a test comment", authorReliability: 0, likes: 1, likers: [], dislikers: []))
    }
}
