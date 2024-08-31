//
//  WidgetConfigurationBuilder.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

class WidgetConfigurationBuilder {
    
    private var configuration: ModuliteWidgetConfiguration
    
    init(style: WidgetStyle, apps: [AppInfo?]) {
        var modules: [ModuleConfiguration] = []
        
        apps.forEach { app in
            guard let app = app else {
                modules.append(
                    ModuleConfiguration.empty(style: style)
                )
                return
            }
            
            modules.append(
                ModuleConfiguration(
                    appName: app.name,
                    associatedURLScheme: URL(string: app.urlScheme),
                    selectedStyle: style.getRandomStyle(),
                    selectedColor: nil
                )
            )
        }
        configuration = ModuliteWidgetConfiguration(
            style: style,
            modules: modules
        )
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
    
    // MARK: - Useful Methods
    
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0, sourceIndex < configuration.modules.count,
              destinationIndex >= 0, destinationIndex < configuration.modules.count else {
            print("Invalid indices")
            return
        }
        
        let movingItem = configuration.modules[sourceIndex]
        configuration.modules.remove(at: sourceIndex)
        configuration.modules.insert(movingItem, at: destinationIndex)
    }
    
    // MARK: - Getters
    
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
    
    // MARK: - Build
    func build() {
        
    }
}
