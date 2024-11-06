//
//  WidgetSchema.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class WidgetSchema: Cloneable {
    
    // MARK: - Properties
    let id: UUID = UUID()
    let type: WidgetType
    var widgetStyle: WidgetStyle
    var name: String?
    var modules: [WidgetModule] = []
    
    var previewImage: UIImage?
    
    var availableModuleStyles: [ModuleStyle] {
        widgetStyle.getModuleStyles(for: type)
    }
    
    var createdAt: Date
    
    // MARK: - Initializers
    
    init(
        type: WidgetType,
        style: WidgetStyle,
        name: String? = nil,
        modules: [WidgetModule] = [],
        createdAt: Date = .now
    ) {
        self.type = type
        self.widgetStyle = style
        self.name = name
        self.modules = modules
        self.createdAt = createdAt
    }
    
    init(content: WidgetContent) {
        type = content.type
        widgetStyle = content.style
        name = content.name
        createdAt = .now
    }
    
    required convenience init(_ prototype: WidgetSchema) {
        self.init(
            type: prototype.type,
            style: prototype.widgetStyle,
            name: prototype.name,
            modules: prototype.modules
        )
    }
    
    // MARK: - Helper methods
    private func setup(from apps: [AppData?]) {
        for (idx, app) in apps.enumerated() {
            guard let app else {
                addEmptyModule(at: idx)
                continue
            }
            
            let moduleStyle = widgetStyle.getRandomStyle(for: type)
            
            let module = WidgetModule(
                style: moduleStyle,
                position: idx,
                appName: app.name,
                urlScheme: app.urlScheme,
                color: moduleStyle.defaultColor
            )
            
            modules.append(module)
        }
    }
    
    private func addEmptyModule(at position: Int) {
        modules.append(
            WidgetModule.createEmpty(
                of: widgetStyle,
                type: type,
                at: position
            )
        )
    }
}

extension WidgetSchema {
    func changeWidgetStyle(to newStyle: WidgetStyle) {
        for i in 0..<modules.count {
            let module = modules[i]
            
            if module.isEmpty {
                modules[i] = .createEmpty(
                    of: newStyle,
                    type: type,
                    at: module.position
                )
                
                continue
            }
            
            let newModule = newStyle.getRandomStyle(for: type)
            
            modules[i] = WidgetModule(
                style: newModule,
                position: module.position,
                appName: module.appName,
                urlScheme: module.urlScheme,
                color: newModule.defaultColor
            )
        }
    }
}
