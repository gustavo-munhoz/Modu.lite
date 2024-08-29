//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

/// Manages the overall configuration of a widget, including its background and modules.
class WidgetConfiguration {
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

/// Finalizes the configuration of a widget, simplifying it by removing options and keeping only selected settings.
class WidgetFinalConfiguration {
    var modules: [ModuleConfiguration?]

    /// Creates a finalized configuration from a given WidgetConfiguration, focusing on selected options.
    init(from configuration: WidgetConfiguration) {
        self.modules = configuration.modules.map { module in
            return ModuleConfiguration(
                appName: module.appName,
                associatedURLScheme: module.associatedURLScheme,
                selectedStyle: module.selectedStyle,
                selectedColor: module.selectedColor
            )
        }
    }
}
