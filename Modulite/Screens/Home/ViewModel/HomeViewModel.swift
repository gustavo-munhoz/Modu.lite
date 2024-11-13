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
    
    func getIndexFor(_ schema: WidgetSchema, type: WidgetType) -> Int? {
        switch type {
        case .main:
            return mainWidgets.firstIndex(where: { $0.id == schema.id })
            
        case .auxiliary:
            return auxiliaryWidgets.firstIndex(where: { $0.id == schema.id })
            
        @unknown default:
            fatalError("Invalid widget type")
        }
    }
    
    // MARK: - Actions
    
    func addWidget(_ schema: WidgetSchema, type: WidgetType) {
        switch type {
        case .main:
            mainWidgets.insert(schema, at: 0)
            
        case .auxiliary:
            auxiliaryWidgets.insert(schema, at: 0)
            
        @unknown default:
            fatalError("Invalid widget type")
        }
    }
    
    func updateWidget(_ schema: WidgetSchema, type: WidgetType) {
        guard let idx = getIndexFor(schema, type: type) else {
            print("Tried to update a widget at an invalid index.")
            return
        }
        switch type {
        case .main:
            mainWidgets[idx] = schema
            
        case .auxiliary:
            auxiliaryWidgets[idx] = schema
            
        @unknown default:
            fatalError("Invalid widget type")
        }
    }
    
    func deleteWidget(at idx: Int, type: WidgetType) {
        switch type {
        case .main:
            guard idx >= 0, idx < mainWidgets.count else {
                print("Tried to delete a widget at an invalid index.")
                return
            }
            let id = mainWidgets[idx].id
            CoreDataPersistenceController.shared.deleteWidget(withId: id)
            mainWidgets.remove(at: idx)
        case .auxiliary:
            guard idx >= 0, idx < auxiliaryWidgets.count else {
                print("Tried to delete a widget at an invalid index.")
                return
            }
            let id = auxiliaryWidgets[idx].id
            
            CoreDataPersistenceController.shared.deleteWidget(withId: id)
            auxiliaryWidgets.remove(at: idx)
            
        @unknown default:
            fatalError("Invalid widget type")
        }
    }
    
    func deleteWidget(_ schema: WidgetSchema, type: WidgetType) {
        guard let idx = getIndexFor(schema, type: type) else {
            print("Tried to delete a widget that is not registered")
            return
        }
        deleteWidget(at: idx, type: type)
    }
}
