//
//  WidgetConfigurationBuilder.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

class WidgetConfigurationBuilder {
    
    private var configuration: ModuliteWidgetConfiguration
    
    private var style: WidgetStyle!
    private var apps: [AppInfo] = []
    
    init() {
        configuration = ModuliteWidgetConfiguration()
    }
    
    // MARK: - Setters
        
    func setWidgetStyle(_ style: WidgetStyle) {
        self.style = style
    }
    
    func addSelectedApp(for app: AppInfo) {
        guard apps.count < 6 else {
            print("Tried to select more than 6 apps.")
            return
        }
        
        apps.append(app)
    }
    
    func removeSelectedApp(for app: AppInfo) {
        guard let index = apps.firstIndex(of: app) else {
            print("Tried to remove an app that is not selected.")
            return
        }
        
        apps.remove(at: index)
    }
    
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
        let replacedItem = configuration.modules[destinationIndex]
                
        replacedItem.index = sourceIndex
        movingItem.index = destinationIndex
        
        configuration.modules.remove(at: sourceIndex)
        configuration.modules.insert(movingItem, at: destinationIndex)
    }
    
    // MARK: - Getters
    
    func getCurrentApps() -> [AppInfo] {
        apps
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
    
    // MARK: - Build
    func build() -> ModuliteWidgetConfiguration {
        var finalApps: [AppInfo?] = []
        var modules: [ModuleConfiguration] = []
        
        for i in 0..<6 {
            if i >= apps.count {
                finalApps.append(nil)
                continue
            }
            
            finalApps.append(apps[i])
        }
        
        for (idx, app) in finalApps.enumerated() {
            guard let app = app else {
                modules.append(
                    ModuleConfiguration.empty(style: style, at: idx)
                )
                continue
            }
            
            modules.append(
                ModuleConfiguration(
                    index: idx,
                    appName: app.name,
                    associatedURLScheme: app.urlScheme,
                    selectedStyle: style.getRandomStyle(),
                    selectedColor: nil
                )
            )
        }
        
        return ModuliteWidgetConfiguration(
            style: style,
            modules: modules
        )
    }
}
