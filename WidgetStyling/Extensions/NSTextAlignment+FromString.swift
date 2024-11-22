//
//  NSTextAlignment+FromString.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

extension NSTextAlignment {
    init?(from string: String) {
        switch string.lowercased() {
        case "left":
            self = .left
        case "center":
            self = .center
        case "right":
            self = .right
        case "justified":
            self = .justified
        case "natural":
            self = .natural
        default:
            return nil
        }
    }
}
