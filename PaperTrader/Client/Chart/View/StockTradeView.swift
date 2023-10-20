import SwiftUI

struct StockTradeView: View {
    @State private var isBuying = true
    @State private var amount = ""
    @State private var feedbackMessage = ""

    @ObservedObject var viewModel: StockChartViewModel

    @State private var availableBalance: Double = 1000.0

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
            }
            
            StockChartView(viewModel: viewModel)
                           .frame(height: 200)
                           .padding([.top])

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
                    Text("\(viewModel.stockData.last?.open ?? 0)")
                    Text("\(viewModel.stockData.last?.high ?? 0)")
                    Text("\(viewModel.stockData.last?.low ?? 0)")
                }
                Spacer()
            }
            
            Picker("Transaction Type", selection: $isBuying) {
                Text("Buy").tag(true)
                Text("Sell").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())

            HStack {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: executeTransaction) {
                    Text(isBuying ? "Buy" : "Sell")
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Text(feedbackMessage)
                .foregroundColor(.red)

            Spacer()
        }
        .padding(.top, 20)
    }

    func executeTransaction() {
        guard let amountDouble = Double(amount) else {
            feedbackMessage = "Invalid amount entered."
            return
        }

        let stockPrice = viewModel.currentPrice

        if isBuying {
            let cost = amountDouble * stockPrice
            if cost <= availableBalance {
                availableBalance -= cost
                feedbackMessage = "Successfully bought \(amountDouble) stocks!"
            } else {
                feedbackMessage = "Insufficient funds."
            }
        } else {
            let value = amountDouble * stockPrice
            availableBalance += value
            feedbackMessage = "Successfully sold \(amountDouble) stocks!"
        }
    }
}

#Preview {
    StockTradeView(viewModel: StockChartViewModel(stockSymbol: "AAPL"))
}
