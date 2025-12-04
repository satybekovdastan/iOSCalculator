//
//  Font+Extension.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI

enum MontserratFont: String {
    
    case thin100 = "Montserrat-Thin"
    case extraLight200 = "Montserrat-ExtraLight"
    case light300 = "Montserrat-Light"
    case regular400 = "Montserrat-Regular"
    case medium500 = "Montserrat-Medium"
    case semibold600 = "Montserrat-SemiBold"
    case bold700 = "Montserrat-Bold"
    case extraBold800 = "Montserrat-ExtraBold"
    case black900 = "Montserrat-Black"
    
    func ofSize(_ size: CGFloat) -> Font? {
        Font.custom(self.rawValue, size: size)
    }
    
}

extension Font {
    static func montserrat(ofSize: CGFloat, weight: MontserratFont) -> Font {
        weight.ofSize(ofSize) ?? .system(size: ofSize)
    }
}
