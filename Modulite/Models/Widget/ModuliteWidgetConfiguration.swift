//
//  WidgetModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

class ModuliteWidgetConfiguration: Copying {
    // MARK: - Properties
    
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
    
    // MARK: - Initializers
    
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
    
    required convenience init(_ prototype: ModuliteWidgetConfiguration) {
        guard let style = prototype.widgetStyle else {
            fatalError("Unable to create WidgetStyle from prototype.")
        }
        
        self.init(
            id: prototype.id,
            name: prototype.name,
            style: style,
            modules: prototype.modules,
            createdAt: prototype.createdAt ?? .now
        )
    }
    
    // MARK: - Actions
    
    func randomizeWithNewStyle(_ style: WidgetStyle) {
        for i in 0..<modules.count {
            let module = modules[i]
            if module.isEmpty {
                modules[i] = .empty(style: style, at: module.index)
                continue
            }
            
            modules[i] = .init(
                index: module.index,
                appName: module.appName,
                associatedURLScheme: module.associatedURLScheme,
                selectedStyle: style.getRandomStyle(),
                selectedColor: style.defaultColor
            )
        }
    }
}

// MARK: - Persistence
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
