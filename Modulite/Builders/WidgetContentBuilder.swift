//
//  WidgetContentBuilder.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 11/09/24.
//

class WidgetContentBuilder {
    
    // MARK: - Properties
    private var name: String!
    private var style: WidgetStyle!
    private var apps: [AppInfo] = []
    
    // MARK: - Getters
    func getCurrentApps() -> [AppInfo] {
        apps
    }
    
    func getRandomModuleStyle() -> ModuleStyle {
        style.getRandomStyle()
    }
    
    // MARK: - Setters
    func setWidgetName(_ name: String) {
        self.name = name
    }
    
    func setWidgetStyle(_ style: WidgetStyle) {
        self.style = style
    }
    
    func appendApp(_ app: AppInfo) {
        guard apps.count < 6 else {
            print("Tried to select more than 6 apps.")
            return
        }
        
        apps.append(app)
    }
    
    func removeApp(_ app: AppInfo) {
        guard let index = apps.firstIndex(of: app) else {
            print("Tried to remove an app that is not selected")
            return
        }
        
        apps.remove(at: index)
    }
    
    // MARK: - Build
    func build() -> WidgetContent {
        var finalApps: [AppInfo?] = []
        
        for i in 0..<6 {
            if i >= apps.count {
                finalApps.append(nil)
                continue
            }
            
            finalApps.append(apps[i])
        }
        
        return WidgetContent(name: name, style: style, apps: finalApps)
    }
}
