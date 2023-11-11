//
//  PortfolioChartView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/6/23.
//

import SwiftUI

struct PortfolioChartView: View {
    @ObservedObject var viewModel: PortfolioViewModel

    private var highestPrice: Double {
        viewModel.portfolioData.map { $0.equity }.max() ?? 0
    }

    private var lowestPrice: Double {
        viewModel.portfolioData.map { $0.equity }.min() ?? 0
    }
    
    private var highestTimestamp: Int {
        viewModel.portfolioData.map { $0.timestamp }.max() ?? 0
    }
    
    private var lowestTimestamp: Int {
        viewModel.portfolioData.map { $0.timestamp }.min() ?? 0
    }
    
    private var gradient: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [.clear, .yellow]),
                              startPoint: .bottom,
                              endPoint: .top)
    }

    private var strokeColor: Color {
        return .yellow
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Your Portfolio")
                        .fontWeight(.semibold)
                        .font(.title3)
                        .foregroundStyle(.white)
                    HStack(spacing: 0) {
                        Text("$\(String(describing: viewModel.profit_loss)) ")
                            .foregroundStyle(.white)
                        Text("\(String(describing: viewModel.percent_change))%")
                            .foregroundStyle(viewModel.percent_change >= 0 ? .green : .red)
                    }
                }
                VStack {
                    GeometryReader { geometry in
                        ZStack {
                            // Chart fill and stroke
                            self.fillPath(in: geometry.size)
                                .fill(self.gradient)
                                .opacity(0.5)

                            self.strokePath(in: geometry.size)
                                .stroke(self.strokeColor, lineWidth: 2)
                        }
                    }
                    HStack {
                        Text(lowestTimestamp.getDate().monthDay() ?? "")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Text(highestTimestamp.getDate().monthDay() ?? "")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.lightGray, lineWidth: 2)
        )
    }

    func fillPath(in size: CGSize) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: size.height))
            for i in 0..<viewModel.portfolioData.count {
                let xPosition = size.width * CGFloat(i) / CGFloat(viewModel.portfolioData.count - 1)
                let yPosition = size.height * (1 - CGFloat((viewModel.portfolioData[i].equity - self.lowestPrice) / (self.highestPrice - self.lowestPrice)))
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
        }
    }

    func strokePath(in size: CGSize) -> Path {
        Path { path in
            for i in 0..<viewModel.portfolioData.count {
                let xPosition = size.width * CGFloat(i) / CGFloat(viewModel.portfolioData.count - 1)
                let yPosition = size.height * (1 - CGFloat((viewModel.portfolioData[i].equity - self.lowestPrice) / (self.highestPrice - self.lowestPrice)))

                if i == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                } else {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
        }
    }
    
}

#Preview {
    PortfolioChartView(viewModel: PortfolioViewModel())
}
