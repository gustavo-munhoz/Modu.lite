//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

/// Manages the overall configuration of a widget, including its background and modules.

class ModuliteWidgetConfiguration {
    var name: String?
    var widgetStyle: WidgetStyle?
    var modules: [ModuleConfiguration] = []
    
    var resultingImage: UIImage?
    
    var availableStyles: [ModuleStyle] {
        guard let widgetStyle = widgetStyle else { return [] }
        return widgetStyle.styles
    }
    
    var availableColors: [UIColor] {
        guard let widgetStyle = widgetStyle else { return [] }
        return widgetStyle.colors
    }
    
    init() { }
    
    init(
        name: String? = nil,
        style: WidgetStyle,
        modules: [ModuleConfiguration]
    ) {
        self.name = name
        self.widgetStyle = style
        self.modules = modules
    }
}

extension ModuliteWidgetConfiguration {
    convenience init(persistedConfiguration config: PersistableWidgetConfiguration) {
        guard let key = WidgetStyleKey(rawValue: config.widgetStyleKey) else {
            fatalError("Unable to create WidgetStyle from persisted key.")
        }
        
        guard let moduleArray = config.modules.allObjects as? [PersistableModuleConfiguration] else {
            fatalError("Unable to convert NSArray to [PersistableModuleConfiguration].")
        }
        
        let style = WidgetStyleFactory.styleForKey(key)
        self.init(
            name: config.name,
            style: style,
            modules: moduleArray.map {
                ModuleConfiguration(
                    widgetStyle: style,
                    persistedConfiguration: $0
                )
            }
        )
        
        resultingImage = FileManagerImagePersistenceController.shared.getWidgetImage(with: config.id)
    }
}
