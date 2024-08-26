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
    
    // FIXME: Builder must me instantiated from selected style
    private let builder = WidgetConfigurationBuilder(style: WidgetStyleFactory.styleForKey(.analog))
    
    @Published private(set) var widgetStyles: [UIImage] = [
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!
    ]
    
    private var allApps: [AppInfo]!
    
    @Published private(set) var apps: [AppInfo]
    
    @Published private(set) var selectedApps: [String] = []
    
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
    
    func filterApps(for query: String) {
        guard !query.isEmpty else {
            apps = allApps
            return
        }
        apps = allApps.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    
    func proceedToWidgetEditor() {
        delegate?.navigateToWidgetEditor(withBuilder: builder)
    }
}
