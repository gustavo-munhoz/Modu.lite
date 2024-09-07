//
//  SelectAppsViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import Foundation

class SelectAppsViewModel: NSObject {
    
    @Published private(set) var apps: [AppInfo] = []
    
    override init() {
        apps = CoreDataPersistenceController.shared.fetchApps()
        
        super.init()
    }
}
