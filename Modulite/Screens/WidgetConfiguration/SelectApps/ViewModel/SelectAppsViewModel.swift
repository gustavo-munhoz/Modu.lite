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
    
    private var unfilteredAppList: [SelectableAppInfo]
    
    @Published private(set) var apps: [SelectableAppInfo] = []
    
    override init() {
        unfilteredAppList = CoreDataPersistenceController.shared.fetchApps().map { ($0, false) }
        super.init()
        
        unfilteredAppList.forEach { app in
            apps.append(app)
        }
    }
    
    private var currentFilterQuery: String?
    
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
    
    func filterApps(with query: String) {
        defer { sortApps() }
        
        if query.isEmpty {
            apps = unfilteredAppList
            return
        }
        
        apps = unfilteredAppList.filter { $0.data.name.lowercased().contains(query.lowercased()) }
    }
    
    func selectApp(at idx: Int) {
        guard idx >= 0, idx < apps.count else {
            print("Tried selecting app at an invalid index.")
            return
        }
        
        guard apps.filter({ $0.isSelected }).count < 6 else {
            print("Tried to select more than 6 apps.")
            return
        }
        
        guard let fullIndex = unfilteredAppList.firstIndex(where: {
            $0.data.name == apps[idx].data.name
        }) else {
            print("Could not find an equivalent index for filtered app in unfiltered list.")
            return
        }
        
        apps[idx].isSelected = true
        unfilteredAppList[fullIndex].isSelected = true
        sortApps()
    }
    
    func deselectApp(at idx: Int) {
        guard isAppSelected(at: idx) else {
            print("Tried to deselect an item that is not selected.")
            return
        }
        
        guard let fullIndex = unfilteredAppList.firstIndex(where: {
            $0.data.name == apps[idx].data.name
        }) else {
            print("Could not find an equivalent index for filtered app in unfiltered list.")
            return
        }
        
        apps[idx].isSelected = false
        unfilteredAppList[fullIndex].isSelected = false
        sortApps()
    }
    
    func toggleAppSelection(at idx: Int) {
        if apps[idx].isSelected {
            deselectApp(at: idx)
            return
        }
        
        selectApp(at: idx)
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
