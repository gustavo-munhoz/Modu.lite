//
//  UIFont.Weight+FromString.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

extension UIFont.Weight {
    static func from(string: String?) -> UIFont.Weight {
        guard let string = string?.lowercased() else {
            return .regular
        }
        
        switch string {
        case "ultralight":
            return .ultraLight
        case "thin":
            return .thin
        case "light":
            return .light
        case "regular":
            return .regular
        case "medium":
            return .medium
        case "semibold":
            return .semibold
        case "bold":
            return .bold
        case "heavy":
            return .heavy
        case "black":
            return .black
        default:
            return .regular
        }
    }
}
