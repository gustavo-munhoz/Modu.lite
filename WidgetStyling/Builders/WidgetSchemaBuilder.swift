//
//  WidgetSchemaBuilder.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

public class WidgetSchemaBuilder: Builder {
    
    // MARK: - Properties
    private var schema: WidgetSchema
    
    enum SchemaError: Swift.Error {
        case invalidPosition
        case invalidIndex
        case invalidStyle
        case invalidColor
        case invalidMovement
    }
    
    // MARK: - Initializers
    public init(content: WidgetContent) {
        self.schema = WidgetSchema(content: content)
    }
    
    public init(schema: WidgetSchema) {
        self.schema = schema
    }
    
    // MARK: - Getters
    public func getWidgetId() -> UUID { schema.id }
    
    public func getWallpapers() -> WallpaperSet {
        schema.widgetStyle.getWallpapers()
    }
    
    public func getBackground() -> StyleBackground {
        schema.widgetStyle.getBackground(for: schema.type)
    }
    
    public func getModule(at position: Int) throws -> WidgetModule {
        guard position >= 0, position < schema.modules.count else {
            throw SchemaError.invalidPosition
        }
        
        return schema.modules[position]
    }
    
    public func getCurrentModules() -> [WidgetModule] { schema.modules }
    
    public func getAvailableModuleStyle(at index: Int) throws -> ModuleStyle {
        guard index >= 0, index < schema.availableModuleStyles.count else {
            throw SchemaError.invalidIndex
        }
        
        return schema.availableModuleStyles[index]
    }
    
    public func getAvailableModuleStyles() -> [ModuleStyle] {
        schema.availableModuleStyles
    }
    
    public func getAvailableColorsForModule(at position: Int) throws -> [UIColor] {
        guard position >= 0, position < schema.type.maxModules else {
            throw SchemaError.invalidPosition
        }
        
        return schema.modules[position].availableColors()
    }
    
    public func getAvailableColorForModule(at position: Int, with idx: Int) throws -> UIColor {
        guard position >= 0, position < schema.type.maxModules else {
            throw SchemaError.invalidPosition
        }
        
        let module = schema.modules[position]
        
        guard idx >= 0, idx < module.availableColors().count else {
            throw SchemaError.invalidIndex
        }
        
        return module.availableColors()[idx]
    }
    
    public func isModuleEmpty(at position: Int) throws -> Bool {
        guard position >= 0, position < schema.type.maxModules else {
            throw SchemaError.invalidPosition
        }
        
        return schema.modules[position].isEmpty
    }
    
    // MARK: - Setters
    
    public func setModuleStyle(_ style: ModuleStyle, at position: Int) throws {
        guard position >= 0, position < schema.modules.count else {
            throw SchemaError.invalidPosition
        }
        
        guard let availableStyle = schema.availableModuleStyles.first(
            where: { $0.identifier == style.identifier }
        ) else { throw SchemaError.invalidStyle }
        
        schema.modules[position].style = availableStyle
    }
    
    public func setModuleColor(_ color: UIColor, at position: Int) throws {
        guard position >= 0, position < schema.modules.count else {
            throw SchemaError.invalidPosition
        }
        
        let module = schema.modules[position]
        
        guard module.canSetColor(to: color) else {
            throw SchemaError.invalidColor
        }
        
        module.color = color
    }
    
    public func moveModule(from position: Int, to newPosition: Int) throws {
        guard position != newPosition,
              position >= 0, position < schema.modules.count,
              newPosition >= 0, newPosition < schema.modules.count
        else {
            throw SchemaError.invalidMovement
        }
        
        let movingModule = schema.modules.remove(at: position)
        schema.modules.insert(movingModule, at: newPosition)
        
        for (pos, module) in schema.modules.enumerated() {
            module.position = pos
        }
    }
    
    // MARK: - Build
    public func build() throws -> WidgetSchema {
        schema
    }
}
