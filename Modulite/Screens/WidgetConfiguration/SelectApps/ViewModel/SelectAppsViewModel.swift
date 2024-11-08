//
//  SelectAppsViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import Foundation
import WidgetStyling

typealias SelectableAppData = (data: AppData, isSelected: Bool)

class SelectAppsViewModel: NSObject {
    
    // MARK: - Properties        
    
    private var unfilteredAppList: [SelectableAppData]
    
    @Published private(set) var apps: [SelectableAppData] = []
    
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
        unfilteredAppList.filter { $0.isSelected }.count == 6
    }
    
    func getSelectedAppsCount() -> Int {
        unfilteredAppList.filter { $0.isSelected }.count
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
    
    @discardableResult
    func selectApp(at idx: Int) -> SelectableAppData? {
        guard idx >= 0, idx < apps.count else {
            print("Tried selecting app at an invalid index.")
            return nil
        }
        
        guard apps.filter({ $0.isSelected }).count < 6 else {
            print("Tried to select more than 6 apps.")
            return nil
        }
        
        guard let fullIndex = unfilteredAppList.firstIndex(where: {
            $0.data.name == apps[idx].data.name
        }) else {
            print("Could not find an equivalent index for filtered app in unfiltered list.")
            return nil
        }
        
        defer { sortApps() }
        
        apps[idx].isSelected = true
        unfilteredAppList[fullIndex].isSelected = true
        
        return apps[idx]
    }
    
    @discardableResult
    func selectApp(_ app: AppData) -> SelectableAppData? {
        guard let index = apps.firstIndex(where: { $0.data.name == app.name }) else {
            print("Tried to select an app that is not in apps list.")
            return nil
        }
        
        return selectApp(at: index)
    }
    
    @discardableResult
    func deselectApp(at idx: Int) -> SelectableAppData? {
        guard isAppSelected(at: idx) else {
            print("Tried to deselect an item that is not selected.")
            return nil
        }
        
        guard let fullIndex = unfilteredAppList.firstIndex(where: {
            $0.data.name == apps[idx].data.name
        }) else {
            print("Could not find an equivalent index for filtered app in unfiltered list.")
            return nil
        }
        
        defer { sortApps() }
        
        apps[idx].isSelected = false
        unfilteredAppList[fullIndex].isSelected = false
        
        return apps[idx]
    }
    
    @discardableResult
    func toggleAppSelection(at idx: Int) -> SelectableAppData? {
        if apps[idx].isSelected {
            return deselectApp(at: idx)
        }
        
        return selectApp(at: idx)
    }
    
    private func sortApps() {
        apps.sort {
            if $0.isSelected && $1.isSelected {
                return $0.data.name < $1.data.name
            }
            
            if $0.isSelected != $1.isSelected {
                return $0.isSelected && !$1.isSelected
            }
            
            if $0.data.relevance != $1.data.relevance {
                return $0.data.relevance < $1.data.relevance
            }
            
            return $0.data.name < $1.data.name
        }
    }
}
