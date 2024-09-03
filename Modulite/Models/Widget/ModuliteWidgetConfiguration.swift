//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

/// Manages the overall configuration of a widget, including its background and modules.

class ModuliteWidgetConfiguration {
    let widgetStyle: WidgetStyle
    var modules: [ModuleConfiguration]
    
    var availableStyles: [ModuleStyle] {
        widgetStyle.styles
    }
    
    var availableColors: [UIColor] {
        widgetStyle.colors
    }
    
    init(
        style: WidgetStyle,
        modules: [ModuleConfiguration]
    ) {
        self.widgetStyle = style
        self.modules = modules
    }
}
