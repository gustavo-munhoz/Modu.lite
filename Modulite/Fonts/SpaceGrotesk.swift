//
//  SpaceGrotesk.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/11/24.
//

import UIKit

enum SpaceGrotesk: String {
    case light = "SpaceGrotesk-Light"
    case regular = "SpaceGrotesk-Regular"
    case medium = "SpaceGrotesk-Medium"
    case semibold = "SpaceGrotesk-SemiBold"
    case bold = "SpaceGrotesk-Bold"
}

extension UIFont {
    static func spaceGrotesk(
        forTextStyle textStyle: UIFont.TextStyle,
        weight: UIFont.Weight = .regular
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
                
        let fontName: String
        switch weight {
        case .ultraLight, .thin, .light:
            fontName = SpaceGrotesk.light.rawValue
        case .regular, .medium:
            fontName = SpaceGrotesk.regular.rawValue
        case .semibold:
            fontName = SpaceGrotesk.semibold.rawValue
        case .bold, .heavy, .black:
            fontName = SpaceGrotesk.bold.rawValue
        default:
            fontName = SpaceGrotesk.regular.rawValue
        }
                
        guard let font = UIFont(name: fontName, size: baseSize) else {
            fatalError("Font \(fontName) not found.")
        }
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}
