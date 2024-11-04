//
//  PixelOperator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 03/11/24.
//

import UIKit

enum PixelOperator: String {
    case bold = "PixelOperator8-Bold"
}

extension UIFont {
    static func pixelOperator(
        textStyle: UIFont.TextStyle
    ) -> UIFont {
        let baseSize: CGFloat
        switch textStyle {
        case .largeTitle: baseSize = 34
        case .title1: baseSize = 28
        case .title2: baseSize = 22
        case .title3: baseSize = 20
        case .headline: baseSize = 17
        case .body: baseSize = 17
        case .callout: baseSize = 16
        case .subheadline: baseSize = 15
        case .footnote: baseSize = 13
        case .caption1: baseSize = 12
        case .caption2: baseSize = 11
        default: baseSize = 17
        }
        
        let fontName = PixelOperator.bold.rawValue
        
        guard let font = UIFont(name: fontName, size: baseSize) else {
            fatalError("Font \(fontName) not found.")
        }
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}
