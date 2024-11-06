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
    init(content: WidgetContent) {
        self.schema = WidgetSchema(content: content)
    }
    
    init(schema: WidgetSchema) {
        self.schema = schema
    }
    
    // MARK: - Getters
    func getWidgetId() -> UUID { schema.id }
    
    func getWallpapers() -> WallpaperSet {
        schema.widgetStyle.getWallpapers()
    }
    
    func getBackground() -> StyleBackground {
        schema.widgetStyle.getBackground(for: schema.type)
    }
    
    func getModule(at position: Int) throws -> WidgetModule {
        guard position >= 0, position < schema.modules.count else {
            throw SchemaError.invalidPosition
        }
        
        return schema.modules[position]
    }
    
    func getCurrentModules() -> [WidgetModule] { schema.modules }
    
    func getAvailableModuleStyle(at index: Int) throws -> ModuleStyle {
        guard index >= 0, index < schema.availableModuleStyles.count else {
            throw SchemaError.invalidIndex
        }
        
        return schema.availableModuleStyles[index]
    }
    
    func getAvailableModuleStyles() -> [ModuleStyle] {
        schema.availableModuleStyles
    }
    
    func getAvailableColorsForModule(at position: Int) throws -> [UIColor] {
        guard position >= 0, position < schema.type.maxModules else {
            throw SchemaError.invalidPosition
        }
        
        return schema.modules[position].availableColors()
    }
    
    func getAvailableColorForModule(at position: Int, with idx: Int) throws -> UIColor {
        guard position >= 0, position < schema.type.maxModules else {
            throw SchemaError.invalidPosition
        }
        
        let module = schema.modules[position]
        
        guard idx >= 0, idx < module.availableColors().count else {
            throw SchemaError.invalidIndex
        }
        
        return module.availableColors()[idx]
    }
    
    func isModuleEmpty(at position: Int) throws -> Bool {
        guard position >= 0, position < schema.type.maxModules else {
            throw SchemaError.invalidPosition
        }
        
        return schema.modules[position].isEmpty
    }
    
    // MARK: - Setters
    
    func setModuleStyle(_ style: ModuleStyle, at position: Int) throws {
        guard position >= 0, position < schema.modules.count else {
            throw SchemaError.invalidPosition
        }
        
        guard let availableStyle = schema.availableModuleStyles.first(
            where: { $0.identifier == style.identifier }
        ) else { throw SchemaError.invalidStyle }
        
        schema.modules[position].style = availableStyle
    }
    
    func setModuleColor(_ color: UIColor, at position: Int) throws {
        guard position >= 0, position < schema.modules.count else {
            throw SchemaError.invalidPosition
        }
        
        let module = schema.modules[position]
        
        guard module.canSetColor(to: color) else {
            throw SchemaError.invalidColor
        }
        
        module.color = color
    }
    
    func moveModule(from position: Int, to newPosition: Int) throws {
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
    func build() throws -> WidgetSchema {
        schema
    }
}
