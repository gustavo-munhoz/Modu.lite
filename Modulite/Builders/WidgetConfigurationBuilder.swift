//
//  WidgetConfigurationBuilder.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

class WidgetConfigurationBuilder {
    
    // MARK: - Properties
    private var configuration = ModuliteWidgetConfiguration()
    private let widgetContent: WidgetContent
    
    // MARK: - Initializer
    init(content: WidgetContent) {
        widgetContent = content
        
        configuration.name = content.name
        configuration.widgetStyle = content.style
        
        for (idx, app) in content.apps.enumerated() {
            guard let app = app else {
                configuration.modules.append(
                    ModuleConfiguration.empty(style: content.style, at: idx)
                )
                continue
            }
            
            configuration.modules.append(
                ModuleConfiguration(
                    index: idx,
                    appName: app.name,
                    associatedURLScheme: app.urlScheme,
                    selectedStyle: content.style.getRandomStyle(),
                    selectedColor: nil
                )
            )
        }
    }
    
    init(content: WidgetContent, configuration: ModuliteWidgetConfiguration) {
        widgetContent = content
        self.configuration = configuration
        self.configuration.name = content.name
        self.configuration.widgetStyle = content.style
    }
    
    // MARK: - Getters
    func getWidgetId() -> UUID {
        configuration.id
    }
    
    func getStyleWallpapers() -> (blocked: UIImage, home: UIImage) {
        (widgetContent.style.blockedScreenWallpaperImage, widgetContent.style.homeScreenWallpaperImage)
    }
    
    func getStyleBackground() -> WidgetBackground? {
        widgetContent.style.background
    }
    
    func getModule(at index: Int) -> ModuleConfiguration? {
        guard index >= 0, index < configuration.modules.count else { return nil }
        return configuration.modules[index]
    }
    
    func getCurrentModules() -> [ModuleConfiguration?] {
        configuration.modules
    }
    
    func getAvailableStyle(at index: Int) -> ModuleStyle? {
        guard index >= 0, index < configuration.availableStyles.count else { return nil }
        return configuration.availableStyles[index]
    }
    
    func getAvailableStyles() -> [ModuleStyle] {
        configuration.availableStyles
    }
    
    func getAvailableColor(at index: Int) -> UIColor? {
        guard index >= 0, index < configuration.availableColors.count else { return nil }
        return configuration.availableColors[index]
    }
    
    func getAvailableColors() -> [UIColor] {
        configuration.availableColors
    }
    
    func isModuleEmpty(at index: Int) -> Bool {
        guard index >= 0, index < 6 else { return false }
        return configuration.modules[index].isEmpty
    }
    
    // MARK: - Setters
    func setModuleStyle(at index: Int, style: ModuleStyle) {
        assert(index >= 0 && index < configuration.modules.count, "Tried to insert module at an invalid index.")
        
        if let style = configuration.availableStyles.first(where: { $0.id == style.id }) {
            configuration.modules[index].selectedStyle = style
        } else {
            print("Tried to set a style that is not available.")
        }
        
        configuration.modules[index].selectedStyle = style
    }
    
    func setModuleColor(at index: Int, color: UIColor) {
        assert(index >= 0 && index < configuration.modules.count, "Tried to edit color of module at an invalid index.")
        
        assert(configuration.availableColors.contains(color), "Tried to set a color that is not available.")
        
        configuration.modules[index].selectedColor = color
    }
    
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0, sourceIndex < configuration.modules.count,
              destinationIndex >= 0, destinationIndex < configuration.modules.count else {
            print("Invalid indexes when moving items.")
            return
        }
        
        let movingItem = configuration.modules[sourceIndex]
        configuration.modules.remove(at: sourceIndex)
        configuration.modules.insert(movingItem, at: destinationIndex)
        
        for (index, module) in configuration.modules.enumerated() {
            module.index = index
        }
    }
    
    // MARK: - Build
    func build() -> ModuliteWidgetConfiguration {
        configuration
    }
}
