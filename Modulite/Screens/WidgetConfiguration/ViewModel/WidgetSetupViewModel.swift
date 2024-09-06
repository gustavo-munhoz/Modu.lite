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
        WidgetStyleFactory.styleForKey(.analog),
        WidgetStyleFactory.styleForKey(.analog)
    ]
    
    private var allApps: [AppInfo]!
    
    @Published private(set) var apps: [AppInfo] = []
    
    @Published private(set) var selectedStyle: WidgetStyle?
    @Published private(set) var selectedApps: [AppInfo] = []
            
    override init() {
        super.init()
        allApps = CoreDataPersistenceController.shared.fetchApps()
        apps = allApps
        selectedApps.append(apps[0])
    }
    
    // MARK: - Setters
    
    func setWidgetId(to id: UUID) {
        self.widgetId = id
    }
    
    // MARK: - Actions
    
    func selectStyle(at index: Int) {
        guard index >= 0, index < widgetStyles.count else {
            print("Tried selecting a style at an invalid index.")
            return
        }
        
        guard selectedStyle != widgetStyles[index] else {
            print("Tried to select an already selected style.")
            return
        }
        
        selectedStyle = widgetStyles[index]
    }
    
    func clearSelectedStyle() {
        selectedStyle = nil
    }
    
    func selectApp(at index: Int) {
        guard index >= 0, index < apps.count else {
            print("Tried selecting app at an invalid index.")
            return
        }
        
        guard selectedApps.count < 6 else {
            print("Tried to select more than 6 apps.")
            return
        }
        
        selectedApps.append(apps[index])
    }
    
    func filterApps(for query: String) {
        guard !query.isEmpty else {
            apps = allApps
            return
        }
        apps = allApps.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    
    func createWidgetBuilder() -> WidgetConfigurationBuilder {
        guard let selectedStyle = selectedStyle else {
            fatalError("Tried to create a Builder without selecting a style.")
        }
        
        guard selectedApps.count > 0, selectedApps.count <= 6 else {
            fatalError("Tried to create a Builder with an invalid number of apps.")
        }
        
        var finalAppList: [AppInfo?] = selectedApps
        
        while finalAppList.count < 6 {
            finalAppList.append(nil)
        }
        
        let builder = WidgetConfigurationBuilder(
            style: selectedStyle,
            apps: finalAppList
        )
        
        return builder
    }
}
