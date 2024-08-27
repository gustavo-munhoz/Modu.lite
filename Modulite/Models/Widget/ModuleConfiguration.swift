//
//  ModuleConfiguration.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/08/24.
//

import UIKit

/// Represents the style of a module, allowing the choice from multiple styles.
class ModuleStyle {
    let id = UUID()
    unowned var widgetStyle: WidgetStyle
    var image: UIImage
    
    /// Initializes a new style with an optional image.
    init(from style: WidgetStyle, imageName: String) {
        self.widgetStyle = style
        self.image = UIImage(named: imageName)!
    }
}

/// Stores configuration settings for an individual module within the widget.
class ModuleConfiguration {
    var appName: String
    var associatedURLScheme: URL?
    var selectedStyle: ModuleStyle
    var selectedColor: UIColor?
    var textConfiguration: ModuleAppNameTextConfiguration {
        selectedStyle.widgetStyle.textConfiguration
    }
    
    var resultingImage: UIImage? {
        if let color = selectedColor {
            return ImageProcessingFactory.createColorBlendedImage(
                selectedStyle.image,
                mode: .plusDarker,
                color: color
            )
        } else {
            return selectedStyle.image
        }
    }
    
    /// Initializes a new module configuration with detailed customization options.
    init(
        appName: String,
        associatedURLScheme: URL?,
        selectedStyle: ModuleStyle,
        selectedColor: UIColor?
    ) {
        self.appName = appName
        self.associatedURLScheme = associatedURLScheme
        self.selectedStyle = selectedStyle
        self.selectedColor = selectedColor
    }
}
