//
//  WidgetSetupViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit
import Combine
import SwiftData

class WidgetSetupViewModel: NSObject {
        
    private(set) weak var delegate: HomeNavigationFlowDelegate?
    
    private(set) var widgetId: UUID!
    
    private let appsDatabase: AppInfoDatabaseService
    
    @Published private(set) var widgetStyles: [WidgetStyle] = [
        WidgetStyleFactory.styleForKey(.analog),
        WidgetStyleFactory.styleForKey(.analog),
        WidgetStyleFactory.styleForKey(.analog)
    ]
    
    private var allApps: [AppInfo]!
    
    @Published private(set) var apps: [AppInfo]
    
    @Published private(set) var selectedStyle: WidgetStyle?
    @Published private(set) var selectedApps: [AppInfo] = []
    
    init(appInfoDatabase: AppInfoDatabaseService) {
        appsDatabase = appInfoDatabase
        
        allApps = appsDatabase.fetchApps()
        apps = allApps
    }
    
    // MARK: - Setters
    
    func setDelegate(to delegate: HomeNavigationFlowDelegate) {
        self.delegate = delegate
    }
    
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
    
    func proceedToWidgetEditor() {
        guard let selectedStyle = selectedStyle else {
            fatalError("Tried to create a Builder without selecting a style.")
        }
        
        guard selectedApps.count > 0, selectedApps.count <= 6 else {
            fatalError("Tried to create a Builder with an invalid number of apps.")
        }
        
        let builder = WidgetConfigurationBuilder(
            style: selectedStyle,
            apps: selectedApps
        )
        delegate?.navigateToWidgetEditor(withBuilder: builder)
    }
}
