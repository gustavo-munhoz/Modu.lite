//
//  StyleBackgroundConfiguration.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

enum StyleBackground {
    case image(UIImage)
    case color(UIColor)
}

public struct StyleBackgroundConfiguration {
    let mainBackground: StyleBackground
    let auxBackground: StyleBackground
}
