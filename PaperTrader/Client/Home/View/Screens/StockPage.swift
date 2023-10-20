//
//  StockPage.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import SwiftUI

struct StockPage: View {
    
    @StateObject var vm: StockPageViewModel
    @StateObject var chartVM: StockChartViewModel
    @State var comments = [Comment]()
    
    @FocusState var keyboardIsUp: Bool
    @State var height: CGFloat = 25
    
    init(stock: Stock) {
        _vm = StateObject(wrappedValue: StockPageViewModel(stock: stock))
        _chartVM = StateObject(wrappedValue: StockChartViewModel(stockSymbol: stock.symbol))
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack {
                        StockTradeView(viewModel: chartVM)
                        
                        VStack(alignment: .leading) {
                            ForEach(vm.comments, id: \.id) { comment in
                                CommentView(comment: comment)
                            }
                        }
                        
                    }
                    .task {
                        try? await vm.fetchComments()
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Spacer()
                            .frame(height: 5)
                    }
                }
            }
            .refreshable {
                try? await vm.fetchComments()
            }
            .scrollDismissesKeyboard(.immediately)
            .safeAreaInset(edge: .bottom, content: {
                chatBottomBar
                    .background(Color(.init(white: 1, alpha: 1)).ignoresSafeArea())
            })
        }
    }
    
    // MARK: Input Bar
    private var chatBottomBar: some View {
        HStack(spacing: 8) {
            ResizableTextField(text: $vm.inputText, height: self.$height, placeholder: "Message...")
                .frame(height: self.height < 150 ? self.height : 150)
                .focused($keyboardIsUp)
                .padding(.leading, 8)
                .background(Color.clear)

            sendButton
                .padding(.trailing, 8)
        }
        .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        .cornerRadius(50)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var sendButton: some View {
        Button(action: {
            vm.sendMessage()
        }, label: {
            if vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Send")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(ColorTheme.darkerLightGray)
            } else {
                Text("Send")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
        })
        .padding(.horizontal, 5)
        .padding(.vertical, 8)
    }
}

#Preview {
    StockPage(stock: Stock(name: "Apple", symbol: "AAPL"))
}
