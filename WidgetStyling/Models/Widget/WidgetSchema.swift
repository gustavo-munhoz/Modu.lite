//
//  WidgetSchema.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class WidgetSchema: Cloneable {
    
    // MARK: - Properties
    public let id: UUID = UUID()
    public let type: WidgetType
    public var widgetStyle: WidgetStyle
    public var name: String?
    public var modules: [WidgetModule] = []
    public var previewImage: UIImage?
    public var lastEditedAt: Date
    
    var availableModuleStyles: [ModuleStyle] {
        widgetStyle.getModuleStyles(for: type)
    }
    
    // MARK: - Initializers
    
    public init(
        type: WidgetType,
        style: WidgetStyle,
        name: String? = nil,
        modules: [WidgetModule] = [],
        lastEditedAt: Date = .now
    ) {
        self.type = type
        self.widgetStyle = style
        self.name = name
        self.modules = modules
        self.lastEditedAt = lastEditedAt
    }
    
    init(content: WidgetContent) {
        type = content.type
        widgetStyle = content.style
        name = content.name
        
        for (pos, app) in content.apps.enumerated() {
            let module = if app == nil {
                widgetStyle.getEmptyModuleStyle(for: type)
            } else {
                widgetStyle.getRandomModuleStyle(for: type)
            }
            
            modules.append(
                WidgetModule(
                    style: module,
                    position: pos,
                    appName: app?.name,
                    urlScheme: app?.urlScheme,
                    color: module.defaultColor
                )
            )
        }
        
        lastEditedAt = .now
    }
    
    public required convenience init(_ prototype: WidgetSchema) {
        self.init(
            type: prototype.type,
            style: prototype.widgetStyle,
            name: prototype.name,
            modules: prototype.modules
        )
    }
    
    // MARK: - Helper methods
    public func getBackground() -> StyleBackground {
        widgetStyle.getBackground(for: self.type)
    }
    
    private func setup(from apps: [AppData?]) {
        for (idx, app) in apps.enumerated() {
            guard let app else {
                addEmptyModule(at: idx)
                continue
            }
            
            let moduleStyle = widgetStyle.getRandomModuleStyle(for: type)
            
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
    public func changeWidgetStyle(to newStyle: WidgetStyle) {
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
            
            let newModule = newStyle.getRandomModuleStyle(for: type)
            
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
