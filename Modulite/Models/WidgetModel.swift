//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

/// Represents the style of a module, allowing the choice from multiple styles.
class ModuleStyle {
    let id = UUID()
    var image: UIImage
    
    /// Initializes a new style with an optional image.
    init(imageName: String) {
        self.image = UIImage(named: imageName)!
    }
}

/// Stores configuration settings for an individual module within the widget.
class ModuleConfiguration {
    var appName: String
    var associatedURLScheme: URL?
    var selectedStyle: ModuleStyle
    var selectedColor: UIColor
    var resultingImage: UIImage? {
        ImageProcessingFactory.createColorBlendedImage(
            selectedStyle.image,
            mode: .plusDarker,
            color: selectedColor
        )
    }
    
    /// Initializes a new module configuration with detailed customization options.
    init(
        appName: String,
        associatedURLScheme: URL?,
        selectedStyle: ModuleStyle,
        selectedColor: UIColor
    ) {
        self.appName = appName
        self.associatedURLScheme = associatedURLScheme
        self.selectedStyle = selectedStyle
        self.selectedColor = selectedColor
    }
}

/// Manages the overall configuration of a widget, including its background and modules.
class WidgetConfiguration {
    let widgetStyle: WidgetStyle
    
    var backgroundImage: UIImage?
    var modules: [ModuleConfiguration?]
    
    var availableStyles: [ModuleStyle] {
        widgetStyle.styles
    }
    
    var availableColors: [UIColor] {
        widgetStyle.colors
    }
    
    init(
        style: WidgetStyle,
        backgroundImage: UIImage?,
        modules: [ModuleConfiguration?]
    ) {
        self.widgetStyle = style
        self.backgroundImage = backgroundImage
        self.modules = modules
    }
}

/// Finalizes the configuration of a widget, simplifying it by removing options and keeping only selected settings.
class WidgetFinalConfiguration {
    var backgroundImage: UIImage?
    var modules: [ModuleConfiguration?]

    /// Creates a finalized configuration from a given WidgetConfiguration, focusing on selected options.
    init(from configuration: WidgetConfiguration) {
        self.backgroundImage = configuration.backgroundImage
        self.modules = configuration.modules.map { module in
            guard let module = module else { return nil }
            
            return ModuleConfiguration(
                appName: module.appName,
                associatedURLScheme: module.associatedURLScheme,
                selectedStyle: module.selectedStyle,
                selectedColor: module.selectedColor
            )
        }
    }
}
