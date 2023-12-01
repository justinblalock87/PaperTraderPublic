//
//  ColorTheme.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation
import SwiftUI
import UIKit

struct DarkColorTheme {
    static let darkBackground = Color.init(red: 30/255, green: 30/255, blue: 30/255)
    static let darkPopup = Color.init(red: 50/255, green: 50/255, blue: 50/255)
    static let darkGray = Color(white: 0.2)
    static let lightGray = Color(white: 0.6)
}

struct ColorTheme {
    
    static let black = Color(red: 20/255, green: 20/255, blue: 20/255, opacity: 1)
    static let primaryColor = Color(red: 55/255, green: 115/255, blue: 245/255, opacity: 1)
    static let primaryUIColor = UIColor(red: 143/255, green: 223/255, blue: 143/255, alpha: 1)
    static let primaryColorFade = Color(red: 143/255, green: 223/255, blue: 143/255, opacity: 0.5)
    static let primaryColorFadeBackground = Color(red: 143/255, green: 223/255, blue: 143/255, opacity: 0.2)
    
    static let secondaryColor = Color(red: 219/255, green: 169/255, blue: 0/255)
    static let secondaryUIColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    static let secondaryColorFade = Color(red: 255/255, green: 215/255, blue: 0/255, opacity: 0.5)
    static let secondaryColorFadeBackground = Color(red: 219/255, green: 169/255, blue: 0/255, opacity: 0.2)

    static let buttonDisabledColor = Color(red: 247/255, green: 247/255, blue: 249/255)
    static let buttonDisabledTitleColor = Color(red: 183/255, green: 192/255, blue: 199/255)

    static let dividerColor = Color(red: 222/255, green: 222/255, blue: 222/255)
    static let outlineGrayColor = Color(red: 240/255, green: 240/255, blue: 240/255)

    static let blue = Color(red: 97/255, green: 227/255, blue: 255/255, opacity: 1)
    static let blueFade = Color(red: 97/255, green: 227/255, blue: 255/255, opacity: 0.5)

    static let lightGray = Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1)
    static let darkerLightGray = Color(red: 228/255, green: 228/255, blue: 228/255, opacity: 1)
    static let gray = Color(red: 220/255, green: 220/255, blue: 220/255, opacity: 1)
    static let grayUIColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let newGray = Color(red: 153/255, green: 153/255, blue: 153/255, opacity: 1)
    static let darkGray = Color(red: 112/255, green: 112/255, blue: 112/255, opacity: 1)
    static let darkGrayUIColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    static let headerGray = Color(red: 170/255, green: 170/255, blue: 170/255)
    
    static let placeholderGray = Color(red: 211/255, green: 211/255, blue: 213/255, opacity: 1)
    static let goodGray = Color(red: 137/255, green: 145/255, blue: 158/255)
}
