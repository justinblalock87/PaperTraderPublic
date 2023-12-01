//
//  TrendingView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import SwiftUI

struct TrendingView: View {
    
    @StateObject var vm = TrendingViewModel()
    @StateObject var infoVM = InfoViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .center) {
                    Text("Top posts across all stocks")
                        .font(.system(size: 18, weight: .semibold))
                    InfoView(infoText: "The rating scores next to users' names show how reputable they are. It may be wise to take advice from more experienced traders.")
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    ForEach(vm.topComments, id: \.id) { comment in
                        CommentView(comment: comment, shouldShowSymbol: true)
                    }
                }
                .padding(.horizontal)
            }
            .analyticsScreen(name: "Trending")
            .navigationTitle("Trending")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                try? await vm.fetchTopComments()
            }
            .environmentObject(infoVM)
            .popup(isPresented: $infoVM.shouldShowInfo) {
                InfoPopupView(infoText: infoVM.infoText, infoLink: infoVM.infoLink)
            } customize: {
                $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.4))
                .isOpaque(true)
            }
        }
    }
}

#Preview {
    TrendingView()
}
