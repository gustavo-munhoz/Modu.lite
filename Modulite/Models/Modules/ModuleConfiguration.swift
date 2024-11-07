//
//  ModuleConfiguration.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/08/24.
//

import UIKit
import SwiftData

/// Stores configuration settings for an individual module within the widget.
@available(*, deprecated)
class ModuleConfiguration {
    var isEmpty: Bool {
        appName == nil
    }
    
    var index: Int
    var appName: String?
    var associatedURLScheme: URL?
    var selectedStyle: ModuleStyle
    var selectedColor: UIColor?
    
    var textConfiguration: ModuleAppNameTextConfiguration {
        selectedStyle.widgetStyle.textConfiguration
    }
    
    var resultingImage: UIImage? {
        let lightModeImage = selectedStyle.image.withConfiguration(
            UIImage.Configuration(traitCollection: .init(userInterfaceStyle: .light))
        )
        
        if let color = selectedColor,
           let blendMode = selectedStyle.widgetStyle.imageBlendMode {
            return ImageProcessingFactory.createColorBlendedImage(
                lightModeImage,
                mode: blendMode,
                color: color
            )
        }
        
        return lightModeImage
    }
    
    /// Initializes a new module configuration with detailed customization options.
    init(
        index: Int,
        appName: String?,
        associatedURLScheme: URL?,
        selectedStyle: ModuleStyle,
        selectedColor: UIColor?
    ) {
        self.index = index
        self.appName = appName
        self.associatedURLScheme = associatedURLScheme
        self.selectedStyle = selectedStyle
        self.selectedColor = selectedColor
    }
    
    func generateWidgetButtonImage() -> UIImage? {
        let cell = WidgetModuleCell()
        cell.setup(with: self)
        cell.frame = CGRect(
            x: 0,
            y: 0,
            width: 108,
            height: 170
        )
        cell.layoutIfNeeded()
        
        let image = cell.asImage()
        
        if image.size.width == .zero || image.size.height == .zero {
            print("Generated image with invalid dimensions: \(image.size).")
            return nil
        }
        
        return image
    }
}

extension ModuleConfiguration {
    static func empty(style: WidgetStyle, at idx: Int) -> ModuleConfiguration {
        guard let style = style.emptyModuleStyle else {
            fatalError("WidgetStyle does not have an empty module style.")
        }
        
        return ModuleConfiguration(
            index: idx,
            appName: nil,
            associatedURLScheme: nil,
            selectedStyle: style,
            selectedColor: nil
        )
    }
}

extension ModuleConfiguration {
    convenience init(
        widgetStyle: WidgetStyle,
        persistedConfiguration config: PersistableModuleConfiguration
    ) {
        guard let key = ModuleStyleKey(rawValue: config.selectedStyleKey) else {
            fatalError("Unable to create ModuleStyle from persisted key.")
        }
        
        self.init(
            index: Int(config.index),
            appName: config.appName,
            associatedURLScheme: config.urlScheme,
            selectedStyle: ModuleStyle(from: widgetStyle, key: key),
            selectedColor: config.selectedColor
        )
    }
}

extension Array where Element: ModuleConfiguration {
    mutating func replace(at idx: Int, with module: Element) {
        replaceSubrange(
            idx...idx,
            with: [module]
        )
    }
}
