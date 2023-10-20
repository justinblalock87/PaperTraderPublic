//
//  DimView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import SwiftUI

struct DimView: View {

    @Binding var isSaving: Bool
    @Binding var isShowingPickerOptions: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.6)
                .onTapGesture {
                    if isShowingPickerOptions {
                        withAnimation {
                            isShowingPickerOptions = false
                        }
                    }
                }
            if isSaving {
                LoadingIndicator()
            }
        }
    }
}

struct LoadingIndicator: View {

    @State var animate = false
    var size: CGFloat = 50

    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [ColorTheme.primaryColor.opacity(0.2), ColorTheme.primaryColor]),
                                        center: .center,
                                        startAngle: .degrees(0),
                                        endAngle: .degrees(270)),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.9).repeatForever(autoreverses: false), value: animate)
        }
        .onAppear(perform: {
            self.animate = true
        })
    }
}
