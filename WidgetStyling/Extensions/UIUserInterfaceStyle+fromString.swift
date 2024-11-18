//
//  UIUserInterfaceStyle+fromString.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 18/11/24.
//

import UIKit

extension UIUserInterfaceStyle {
    static func fromString(_ string: String?) -> UIUserInterfaceStyle? {
        switch string?.lowercased() {
        case "dark":
            return .dark
        case "light":
            return .light
        default:
            return nil
        }
    }
}
