//
//  HomeViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit

class HomeViewModel: NSObject {
    
    // MARK: - Properties
    
    @Published var mainWidgets: [ModuliteWidgetConfiguration]
    
    @Published var auxiliaryWidgets: [UIImage] = [
        UIImage(systemName: "trash.fill")!,
        UIImage(systemName: "trash.fill")!
    ]
    
    @Published var tips: [UIImage] = []
    
    // MARK: - Init
    
    override init() {
        let persistedWidgets = CoreDataPersistenceController.shared.fetchWidgets()
        mainWidgets = persistedWidgets.map {
            ModuliteWidgetConfiguration(persistedConfiguration: $0)
        }
        super.init()
    }
    
    // MARK: - Getters
    
    func getIndexFor(_ config: ModuliteWidgetConfiguration) -> Int? {
        guard let index = mainWidgets.firstIndex(where: { $0.id == config.id }) else {
            print("Widget not found in data source")
            return nil
        }
        
        return index
    }
    
    // MARK: - Actions
    
    func addMainWidget(_ configuration: ModuliteWidgetConfiguration) {
        mainWidgets.insert(configuration, at: 0)
    }
    
    func updateMainWidget(_ configuration: ModuliteWidgetConfiguration) {
        guard let idx = getIndexFor(configuration) else {
            print("Tried to update a widget at an invalid index.")
            return
        }
        
        mainWidgets[idx] = configuration
    }
    
    func deleteMainWidget(at idx: Int) {
        guard idx >= 0, idx < mainWidgets.count else {
            print("Tried to delete a widget at an invalid index.")
            return
        }
            
        let id = mainWidgets[idx].id
        CoreDataPersistenceController.shared.deleteWidget(withId: id)
        mainWidgets.remove(at: idx)
    }
    
    func deleteMainWidget(_ configuration: ModuliteWidgetConfiguration) {
        guard let idx = mainWidgets.firstIndex(where: { $0.id == configuration.id }) else {
            print("Tried to delete a widget that is not registered")
            return
        }
        
        deleteMainWidget(at: idx)
    }
}
