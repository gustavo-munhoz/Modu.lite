//
//  ModuleConfiguration.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/08/24.
//

import UIKit
import SwiftData

/// Stores configuration settings for an individual module within the widget.
class ModuleConfiguration {
    var isEmpty: Bool {
        appName == nil
    }
    
    var appName: String?
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
        appName: String?,
        associatedURLScheme: URL?,
        selectedStyle: ModuleStyle,
        selectedColor: UIColor?
    ) {
        self.appName = appName
        self.associatedURLScheme = associatedURLScheme
        self.selectedStyle = selectedStyle
        self.selectedColor = selectedColor
    }
    
    func generateWidgetButtonImageData() -> Data? {
        let cell = WidgetModuleCell()
        cell.setup(with: self)
        cell.frame = CGRect(
            x: 0,
            y: 0,
            width: 108,
            height: 170
        )
        cell.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(bounds: cell.bounds)
        
        let image = renderer.image { rendererContext in
            cell.layer.render(in: rendererContext.cgContext)
        }
        return image.pngData()
    }
}

extension ModuleConfiguration {
    static func empty(style: WidgetStyle) -> ModuleConfiguration {
        guard let style = style.emptyModuleStyle else {
            fatalError("WidgetStyle does not have an empty module style.")
        }
        
        return ModuleConfiguration(
            appName: nil,
            associatedURLScheme: nil,
            selectedStyle: style,
            selectedColor: nil
        )
    }
}
