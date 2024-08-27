//
//  ModuleConfiguration.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/08/24.
//

import UIKit

/// Stores configuration settings for an individual module within the widget.
class ModuleConfiguration {
    var appName: String
    var associatedURLScheme: URL?
    var selectedStyle: ModuleStyle
    var selectedColor: UIColor?
    var textConfiguration: ModuleAppNameTextConfiguration
    
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
        selectedColor: UIColor?,
        textConfiguration: ModuleAppNameTextConfiguration
    ) {
        self.appName = appName
        self.associatedURLScheme = associatedURLScheme
        self.selectedStyle = selectedStyle
        self.selectedColor = selectedColor
        self.textConfiguration = textConfiguration
    }
}
