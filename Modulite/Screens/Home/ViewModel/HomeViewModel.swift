//
//  HomeViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import WidgetStyling

class HomeViewModel: NSObject {
    
    // MARK: - Properties
    
    @Published var mainWidgets: [WidgetSchema]
    
    @Published var auxiliaryWidgets: [WidgetSchema]
    
    @Published var tips: [UIImage] = []
    
    // MARK: - Init
    
    override init() {
        mainWidgets = CoreDataPersistenceController.shared.fetchMainWidgets()
        auxiliaryWidgets = CoreDataPersistenceController.shared.fetchAuxWidgets()
        
        super.init()
    }
    
    // MARK: - Getters
    
    func getIndexFor(_ schema: WidgetSchema) -> Int? {
        guard let index = mainWidgets.firstIndex(where: { $0.id == schema.id }) else {
            print("Widget not found in data source")
            return nil
        }
        
        return index
    }
    
    // MARK: - Actions
    
    func addMainWidget(_ schema: WidgetSchema) {
        mainWidgets.insert(schema, at: 0)
    }
    
    func updateMainWidget(_ schema: WidgetSchema) {
        guard let idx = getIndexFor(schema) else {
            print("Tried to update a widget at an invalid index.")
            return
        }
        
        mainWidgets[idx] = schema
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
    
    func deleteMainWidget(_ schema: WidgetSchema) {
        guard let idx = mainWidgets.firstIndex(where: { $0.id == schema.id }) else {
            print("Tried to delete a widget that is not registered")
            return
        }
        
        deleteMainWidget(at: idx)
    }
}
