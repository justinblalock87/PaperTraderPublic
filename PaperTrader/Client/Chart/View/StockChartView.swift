import SwiftUI

struct StockChartView: View {
    @ObservedObject var viewModel: StockChartViewModel

    // Extracted properties for the chart
    private var highestPrice: Double {
        viewModel.stockData.map { $0.high }.max() ?? 0
    }

    private var lowestPrice: Double {
        viewModel.stockData.map { $0.low }.min() ?? 0
    }

    private var gradient: LinearGradient {
        let isPriceUp = viewModel.stockData.last?.close ?? 0 > viewModel.stockData.first?.close ?? 0
        return LinearGradient(gradient: Gradient(colors: [isPriceUp ? .green : .red, .clear]),
                              startPoint: .bottom,
                              endPoint: .top)
    }

    private var strokeColor: Color {
        let isPriceUp = viewModel.stockData.last?.close ?? 0 > viewModel.stockData.first?.close ?? 0
        return isPriceUp ? .green : .red
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    // Chart fill and stroke
                    self.fillPath(in: geometry.size)
                        .fill(self.gradient)
                        .opacity(0.5)

                    self.strokePath(in: geometry.size)
                        .stroke(self.strokeColor, lineWidth: 2)

                    // Draggable line masked by the chart fill
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [self.strokeColor.opacity(0.5), self.strokeColor]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 2)
                        .alignmentGuide(.bottom) { d in d[.bottom] }
                        .position(x: viewModel.dragOffset, y: geometry.size.height / 2)
                        .mask(self.fillPath(in: geometry.size)) // Masking by the chart fill
                        .overlay(
                            Rectangle()
                                .stroke(self.strokeColor, lineWidth: 1)
                                .blur(radius: 4) // This will give a glow effect
                                .offset(x: 0, y: 2) // Offset a bit to make the glow more pronounced at the bottom
                                .mask(self.fillPath(in: geometry.size))
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let potentialOffset = viewModel.dragOffset + value.translation.width
                                    viewModel.dragOffset = min(max(potentialOffset, 1), geometry.size.width - 1) // Constrain within chart width
                                    let index = Int((viewModel.dragOffset / geometry.size.width) * CGFloat(viewModel.stockData.count - 1))
                                    viewModel.currentPrice = viewModel.stockData[index].close
                                }
                        )
                }
            }
        }
    }

    func fillPath(in size: CGSize) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: size.height))
            for i in 0..<viewModel.stockData.count {
                let xPosition = size.width * CGFloat(i) / CGFloat(viewModel.stockData.count - 1)
                let yPosition = size.height * (1 - CGFloat((viewModel.stockData[i].close - self.lowestPrice) / (self.highestPrice - self.lowestPrice)))
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
        }
    }

    func strokePath(in size: CGSize) -> Path {
        Path { path in
            for i in 0..<viewModel.stockData.count {
                let xPosition = size.width * CGFloat(i) / CGFloat(viewModel.stockData.count - 1)
                let yPosition = size.height * (1 - CGFloat((viewModel.stockData[i].close - self.lowestPrice) / (self.highestPrice - self.lowestPrice)))

                if i == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                } else {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
        }
    }
}
