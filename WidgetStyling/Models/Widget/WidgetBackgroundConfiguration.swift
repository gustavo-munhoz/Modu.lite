//
//  WidgetBackgroundConfiguration.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

enum WidgetBackground {
    case image(UIImage)
    case color(UIColor)
}

public struct WidgetBackgroundConfiguration {
    let mainBackground: WidgetBackground
    let auxBackground: WidgetBackground
}
