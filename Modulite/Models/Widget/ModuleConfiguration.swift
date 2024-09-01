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

extension ModuleConfiguration {
    convenience init(widgetStyle: WidgetStyle, persistedConfiguration config: ModulePersistableConfiguration) {
        var url: URL?
        if let urlString = config.url {
            url = URL(string: urlString)
        }
        
        self.init(
            appName: config.appName,
            associatedURLScheme: url,
            selectedStyle: ModuleStyle(
                from: widgetStyle,
                key: config.moduleKey
            ),
            selectedColor: config.color
        )
    }
    
    // TODO: REFACTOR TO PROTOCOL
    func createPersistableObject() -> ModulePersistableConfiguration {
        guard let data = self.generateWidgetButtonImageData() else {
            fatalError("Unable to generate png data from module cell.")
        }
        
        return ModulePersistableConfiguration(
            appName: appName,
            url: associatedURLScheme?.absoluteString,
            color: selectedColor,
            moduleKey: selectedStyle.key,
            moduleButtonImageData: data
        )
    }
}

@Model
class ModulePersistableConfiguration {
    let appName: String?
    let url: String?
    @Attribute(.transformable(by: UIColorValueTransformer.self)) let color: UIColor?
    let moduleKey: ModuleStyleKey
    
    let moduleButtonImageData: Data
    
    init(
        appName: String?,
        url: String?,
        color: UIColor?,
        moduleKey: ModuleStyleKey,
        moduleButtonImageData: Data
    ) {
        self.appName = appName
        self.url = url
        self.color = color
        self.moduleKey = moduleKey
        self.moduleButtonImageData = moduleButtonImageData
    }
}

@objc(UIColorValueTransformer)
final class UIColorValueTransformer: ValueTransformer {

    override static func transformedValueClass() -> AnyClass {
        return UIColor.self
    }

    // return data
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }

    // return UIColor
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
    
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            return color
        } catch {
            return nil
        }
    }
}
