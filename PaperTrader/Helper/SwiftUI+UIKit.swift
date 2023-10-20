//
//  SwiftUI+UIKit.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import SwiftUI
import UIKit

extension UIViewController {
    func attachSwiftUIView<Content: View>(rootView: Content) -> UIHostingController<Content> {
        let contentView = UIHostingController(rootView: rootView)
        addChild(contentView)
        contentView.view.frame = view.bounds
        view.addSubview(contentView.view)
        contentView.didMove(toParent: self)

        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return contentView
    }
}
