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
        WidgetStyleFactory.styleForKey(.tapedeck),
        WidgetStyleFactory.styleForKey(.retromacWhite),
        WidgetStyleFactory.styleForKey(.retromacGreen)
    ]
    
    @Published private(set) var widgetName: String?
    @Published private(set) var selectedStyle: WidgetStyle?
    @Published private(set) var selectedApps: [AppInfo] = []
    
    // MARK: - Getters
    func getIndexForSelectedStyle() -> Int? {
        guard let selectedStyle = selectedStyle else { return nil }
        return widgetStyles.firstIndex(where: { $0.key == selectedStyle.key })
    }

    func isStyleSelected() -> Bool {
        selectedStyle != nil
    }
    
    // MARK: - Setters
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
    func setWidgetName(to name: String) {
        self.widgetName = name
    }
    
    func setWidgetStyle(to style: WidgetStyle) {
        self.selectedStyle = style
    }
    
    func setSelectedApps(to apps: [AppInfo]) {
        guard apps.count <= 6 else {
            print("Tried to add more than 6 apps at once")
            return
        }
        
        selectedApps = apps
    }
    
    // MARK: - Actions
        
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
    
    func updatePurchaseStatus() {
        for style in widgetStyles {
            style.isPurchased = PurchaseManager.shared.isSkinPurchased(for: style.key.rawValue)
        }
    }
}
