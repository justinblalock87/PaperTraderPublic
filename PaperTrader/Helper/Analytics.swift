//
//  Analytics.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/8/23.
//

import Foundation
import FirebaseAnalytics
import SwiftUI

// Introducing a manual screen view event logging API.
extension View {
    func analyticsScreen(name: String, class screenClass: String? = nil, extraParameters: [String: Any]? = nil) -> some View {
        onAppear {
            var params: [String: Any] = [AnalyticsParameterScreenName: name]
            if let screenClass = screenClass {
                params[AnalyticsParameterScreenClass] = screenClass
            }
            if let extraParams = extraParameters {
                params.merge(extraParams) { _, new in new }
            }
            Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
        }
    }
}
