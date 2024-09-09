//
//  SelectAppsViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import Foundation

typealias SelectableAppInfo = (data: AppInfo, isSelected: Bool)

class SelectAppsViewModel: NSObject {
    
    // MARK: - Properties        
    
    @Published private(set) var apps: [SelectableAppInfo] = []
    
    override init() {
        super.init()
        CoreDataPersistenceController.shared.fetchApps().forEach { app in
            apps.append((app, false))
        }
    }
    
    // MARK: - Getters
    
    func isAppSelected(at idx: Int) -> Bool {
        apps[idx].isSelected
    }
    
    func shouldSelectItem(at idx: Int) -> Bool {
        !isAppSelected(at: idx) && !didReachMaxNumberOfApps()
    }
    
    func didReachMaxNumberOfApps() -> Bool {
        apps.filter { $0.isSelected }.count == 6
    }
    
    func getSelectedAppsCount() -> Int {
        apps.filter { $0.isSelected }.count
    }
    
    // MARK: - Actions
    
    func selectApp(at idx: Int) {
        guard idx >= 0, idx < apps.count else {
            print("Tried selecting app at an invalid index.")
            return
        }
        
        guard apps.filter({ $0.isSelected }).count < 6 else {
            print("Tried to select more than 6 apps.")
            return
        }
        
        apps[idx].isSelected = true
        sortApps()
    }
    
    func deselectApp(at idx: Int) {
        guard isAppSelected(at: idx) else {
            print("Tried to deselect an item that is not selected.")
            return
        }
        
        apps[idx].isSelected = false
        sortApps()
    }
    
    func toggleAppSelection(at idx: Int) {
        if apps[idx].isSelected {
            deselectApp(at: idx)
            return
        }
        
        selectApp(at: idx)
        return
    }
    
    private func sortApps() {
        apps.sort {
            if $0.isSelected == $1.isSelected {
                return $0.data.name < $1.data.name
            }
            return $0.isSelected && !$1.isSelected
        }
    }
}
