//
//  StockPage.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import SwiftUI
import FirebaseAnalytics

struct StockPage: View {
    
    let stock: Stock
    @StateObject var vm: StockPageViewModel
    @StateObject var chartVM: StockChartViewModel
    @State var comments = [Comment]()
    
    @FocusState var keyboardIsUp: Bool
    @State var height: CGFloat = 25
    @State var currentPage = StockPageSegments.Summary
    
    var segueBuySell: ((String, Stock) -> Void)?
    
    init(stock: Stock) {
        self.stock = stock
        _vm = StateObject(wrappedValue: StockPageViewModel(stock: stock))
        _chartVM = StateObject(wrappedValue: StockChartViewModel(stockSymbol: stock.symbol))
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    StockTradeView(viewModel: chartVM)
                        
                    Picker("tabs", selection: $currentPage) {
                        ForEach(StockPageSegments.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    
                    if currentPage == .Summary {
                        summaryView
                    } else if currentPage == .Chat {
                        chatView
                    } else if currentPage == .Learn {
                        learnView
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
            .refreshable {
                try? await vm.fetchComments()
            }
            .scrollDismissesKeyboard(.immediately)
            .safeAreaInset(edge: .bottom, content: {
                if currentPage == .Chat {
                    chatBottomBar
                        .background(Color(.init(white: 0.1, alpha: 1)).ignoresSafeArea())
                } else if currentPage == .Summary {
                    buySellButtons
                        .padding(.horizontal, 15)
                }
            })
        }
        .analyticsScreen(name: "StockPage", extraParameters: ["stock": stock.symbol])
        .background(DarkColorTheme.darkBackground)
        .foregroundColor(.white)
        
    }
    
    private var summaryView: some View {
        VStack {
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Open")
                        .foregroundStyle(ColorTheme.darkGray)
                    Text("High")
                        .foregroundStyle(ColorTheme.darkGray)
                    Text("Low")
                        .foregroundStyle(ColorTheme.darkGray)
                }
                VStack {
                    Text(String(format: "%.2f", chartVM.stockData.last?.open ?? 0))
                    Text(String(format: "%.2f", chartVM.stockData.last?.high ?? 0))
                    Text(String(format: "%.2f", chartVM.stockData.last?.low ?? 0))
                }
                Spacer()
            }
            .padding(.top, 10)
            NewsView()
                .padding(.vertical, 20)
        }
    }
    
    private var chatView: some View {
        VStack(alignment: .leading) {
            ForEach(vm.comments, id: \.id) { comment in
                CommentView(comment: comment)
            }
        }
    }
    
    private var learnView: some View {
        VStack {
            Text("work in progress")
        }
    }
    
    private var buySellButtons: some View {
        VStack {
            HStack {
                Button(action: {
                    segueBuySell?("buy", stock)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.primaryColor)
                            .frame(height: 45)
                        Text("Buy")
                        //                            .font(CustomFonts.sfProButtonTitle)
                            .foregroundColor(.white)
                    }
                })
                    .buttonStyle(.plain)
                
                Button(action: {
                    segueBuySell?("sell", stock)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.primaryColor)
                            .frame(height: 45)
                        Text("Sell")
                        //                            .font(CustomFonts.sfProButtonTitle)
                            .foregroundColor(.white)
                    }
                })
                    .buttonStyle(.plain)
            }
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
        .background(DarkColorTheme.darkGray)
        .cornerRadius(50)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var sendButton: some View {
        Button(action: {
            Analytics.logEvent("sendcomment", parameters: nil)
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
