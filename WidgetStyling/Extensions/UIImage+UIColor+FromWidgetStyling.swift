//
//  UIImage+UIColor+FromWidgetStyling.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

extension UIImage {
    static func fromWidgetStyling(named name: String) -> UIImage? {
        let frameworkBundle = Bundle(for: WidgetSchema.self)
        return UIImage(named: name, in: frameworkBundle, compatibleWith: nil)
    }
}

extension UIColor {
    static func fromWidgetStyling(named name: String) -> UIColor? {
        let frameworkBundle = Bundle(for: WidgetSchema.self)
        return UIColor(named: name, in: frameworkBundle, compatibleWith: nil)
    }
}
