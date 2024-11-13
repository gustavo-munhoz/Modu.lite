//
//  UIFont.TextStyle+FromString.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

extension UIFont.TextStyle {
    static func from(_ string: String) -> UIFont.TextStyle {
        switch string.lowercased() {
        case "large_title": return .largeTitle
        case "title1": return .title1
        case "title2": return .title2
        case "title3": return .title3
        case "headline": return .headline
        case "subheadline": return .subheadline
        case "body": return .body
        case "callout": return .callout
        case "footnote": return .footnote
        case "caption1": return .caption1
        case "caption2": return .caption2
        default: return .body
        }
    }
}
