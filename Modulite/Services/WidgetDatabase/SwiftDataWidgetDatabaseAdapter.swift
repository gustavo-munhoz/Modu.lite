//
//  SwiftDataWidgetDatabaseAdapter.swift
//  Modulite
//
//  Created by André Wozniack on 27/08/24.
//

import Foundation
import SwiftData

class SwiftDataWidgetDatabaseAdapter: WidgetDatabaseService {
    // MARK: - Properties
    
    var container: ModelContainer?
    var context: ModelContext?
    
    // MARK: - Lifecycle
    
    init() {
        do {
            ValueTransformer.setValueTransformer(
                UIColorValueTransformer(),
                forName: NSValueTransformerName("UIColorValueTransformer")
            )
            container = try ModelContainer(for: WidgetPersistableConfiguration.self)
            if let container = self.container {
                context = ModelContext(container)
            }
        } catch {
            print("Error creating container")
        }
    }
    
    func fetchAllWidgets() -> [WidgetPersistableConfiguration] {
        guard let context = context else { return [] }
        let descriptor = FetchDescriptor<WidgetPersistableConfiguration>()
        
        do {
            return try context.fetch(descriptor)
            
        } catch {
            print("Error fetching widgets: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveWidget(configuration: WidgetPersistableConfiguration) {
        guard let context = context else { return }
        
        context.insert(configuration)
        print("Widget saved successfully.")
    }
    
    func fetchWidget(with id: UUID) -> WidgetPersistableConfiguration? {
        guard let context = context else { return nil }
        
        let descriptor = FetchDescriptor<WidgetPersistableConfiguration>()
        
        do {
            let widgets = try context.fetch(descriptor) as [WidgetPersistableConfiguration]
            return widgets.first(where: { $0.id == id })
            
        } catch {
            return nil
        }
    }
    
    func deleteWidget(with id: UUID) {
        guard let context = context else { return }
        let predicate = #Predicate<WidgetPersistableConfiguration> { $0.id == id }
        
        do {
            try context.delete(model: WidgetPersistableConfiguration.self, where: predicate)
        } catch {
            print("Error deleting widget: \(error.localizedDescription)")
        }
    }
}
