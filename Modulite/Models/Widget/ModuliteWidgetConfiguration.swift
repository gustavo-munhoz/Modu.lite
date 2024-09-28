//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

/// Manages the overall configuration of a widget, including its background and modules.

class ModuliteWidgetConfiguration {
    var id: UUID = UUID()
    var name: String?
    var widgetStyle: WidgetStyle?
    var modules: [ModuleConfiguration] = []
    
    var previewImage: UIImage?
    
    var availableStyles: [ModuleStyle] {
        guard let widgetStyle = widgetStyle else { return [] }
        return widgetStyle.styles
    }
    
    var availableColors: [UIColor] {
        guard let widgetStyle = widgetStyle else { return [] }
        return widgetStyle.colors
    }
    
    var createdAt: Date!
    
    init() { }
    
    init(
        id: UUID,
        name: String? = nil,
        style: WidgetStyle,
        modules: [ModuleConfiguration],
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.widgetStyle = style
        self.modules = modules
        self.createdAt = createdAt
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
            id: config.id,
            name: config.name,
            style: style,
            modules: moduleArray.map {
                ModuleConfiguration(
                    widgetStyle: style,
                    persistedConfiguration: $0
                )
            },
            createdAt: config.createdAt
        )
        
        previewImage = FileManagerImagePersistenceController.shared.getWidgetImage(with: config.id)
    }
}
