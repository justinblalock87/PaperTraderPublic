//
//  ResizableTextField.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/16/23.
//

import Foundation
import SwiftUI
import UIKit

struct ResizableTextField: UIViewRepresentable {
    
    @State var hasMadeEdits = false
    @Binding var text: String
    @Binding var height: CGFloat
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        return ResizableTextField.Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = self.placeholder
        view.font = .systemFont(ofSize: 18)
        view.textColor = UIColor.lightGray
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
            if hasMadeEdits && text.isEmpty {
                uiView.text = ""
            }
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: ResizableTextField

        init(parent: ResizableTextField) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.text.isEmpty {
                textView.text = ""
                textView.textColor = .black
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = self.parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
                self.parent.hasMadeEdits = true
            }
        }
    }
}
