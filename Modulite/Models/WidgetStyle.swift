//
//  WidgetStyle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

class WidgetStyle {
    var name: String
    var backgroundImage: UIImage?
    var styles: [ModuleStyle]
    var colors: [UIColor]

    init(
        name: String,
        backgroundImage: UIImage?,
        styles: [ModuleStyle],
        colors: [UIColor]
    ) {
        self.name = name
        self.backgroundImage = backgroundImage
        self.styles = styles
        self.colors = colors
    }
}

enum WidgetStyleKey {
    case analog
}
