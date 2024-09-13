//
//  WidgetSetupViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit

class WidgetSetupViewModel: NSObject {
    
    private(set) var widgetId: UUID!
    
    @Published private(set) var widgetStyles: [WidgetStyle] = [
        WidgetStyleFactory.styleForKey(.analog),
        WidgetStyleFactory.styleForKey(.tapedeck)
    ]
    
    @Published private(set) var selectedStyle: WidgetStyle?
    @Published private(set) var selectedApps: [AppInfo] = []
    
    // MARK: - Getters
    func isStyleSelected() -> Bool {
        selectedStyle != nil
    }
    
    // MARK: - Setters
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
    // MARK: - Actions
    
    func setSelectedApps(to apps: [AppInfo]) {
        guard apps.count <= 6 else {
            print("Tried to add more than 6 apps at once")
            return
        }
        
        selectedApps = apps
    }
    
    func addSelectedApp(_ app: AppInfo) {
        guard selectedApps.count < 6 else {
            print("Tried to add more than 6 apps.")
            return
        }
        
        selectedApps.append(app)
    }
    
    func removeSelectedApp(_ app: AppInfo) {
        guard let index = selectedApps.firstIndex(where: { $0.name == app.name }) else {
            print("Tried to remove an app that is not selected")
            return
        }
        
        selectedApps.remove(at: index)
    }
    
    @discardableResult
    func selectStyle(at index: Int) -> WidgetStyle? {
        guard index >= 0, index < widgetStyles.count else {
            print("Tried selecting a style at an invalid index.")
            return nil
        }
        
        guard selectedStyle != widgetStyles[index] else {
            print("Tried to select an already selected style.")
            return nil
        }
        
        selectedStyle = widgetStyles[index]
        return selectedStyle
    }
    
    func clearSelectedStyle() {
        selectedStyle = nil
    }
        
}
