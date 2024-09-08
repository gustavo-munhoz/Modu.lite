//
//  SelectAppsViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import Foundation

class SelectAppsViewModel: NSObject {
    
    // MARK: - Properties
    @Published private(set) var apps: [AppInfo] = []
    
    @Published private(set) var selectedApps: [AppInfo] = []
    
    override init() {
        apps = CoreDataPersistenceController.shared.fetchApps()
        
        super.init()
    }
    
    // MARK: - Actions
    
    func selectApp(at idx: Int) {
        guard idx >= 0, idx < apps.count else {
            print("Tried selecting app at an invalid index.")
            return
        }
        
        guard selectedApps.count < 6 else {
            print("Tried to select more than 6 apps.")
            return
        }
        
        selectedApps.append(apps[idx])
    }
    
    func isAppSelected(at idx: Int) -> Bool {
        selectedApps.contains(apps[idx])
    }
    
    func deselectApp(at idx: Int) {
        guard isAppSelected(at: idx) else {
            print("Tried to deselect an item that is not selected.")
            return
        }
                
        selectedApps.removeAll { $0 == apps[idx] }
    }
}
