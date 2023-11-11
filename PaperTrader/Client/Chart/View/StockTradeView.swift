import SwiftUI

struct StockTradeView: View {
    @State private var isBuying = true
    @State private var amount = "1.0"
    @State private var feedbackMessage = ""

    @ObservedObject var viewModel: StockChartViewModel
    var timeframes = ["1Y", "1M", "1D"]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.stockSymbol)
                        .font(.system(size: 20, weight: .bold))
                    Text("\(viewModel.currentPrice, specifier: "%.2f")")
                        .font(.system(size: 36, weight: .bold))
                }
                Spacer()
                
                Picker("Timeframe", selection: $viewModel.currentTimeframe) {
                    ForEach(timeframes, id: \.self) {
                        Text($0)
                    }
                }
                .frame(width: 200)
                .pickerStyle(.segmented)
                .onChange(of: viewModel.currentTimeframe, perform: { _ in
                    viewModel.reload()
                })
            }
            
            StockChartView(viewModel: viewModel)
                           .frame(height: 200)
                           .padding([.top])

            Spacer()
        }
        .padding(.top, 20)
    }
}

#Preview {
    StockTradeView(viewModel: StockChartViewModel(stockSymbol: "AAPL"))
}
