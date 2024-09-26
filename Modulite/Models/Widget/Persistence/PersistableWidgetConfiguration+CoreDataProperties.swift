//
//  PersistableWidgetConfiguration+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//
//

import CoreData
import UIKit

extension PersistableWidgetConfiguration {
    @NSManaged var id: UUID
    @NSManaged var name: String?
    @NSManaged var previewImageUrl: URL
    @NSManaged var widgetStyleKey: String
    @NSManaged var modules: NSSet
    @NSManaged var createdAt: Date
}

extension PersistableWidgetConfiguration {
    
    @discardableResult
    static func createFromWidgetConfiguration(
        _ config: ModuliteWidgetConfiguration,
        widgetImage: UIImage,
        using managedObjectContext: NSManagedObjectContext
    ) -> PersistableWidgetConfiguration {
        let widget = PersistableWidgetConfiguration(context: managedObjectContext)
        
        widget.id = UUID()
        widget.name = config.name
        guard let widgetStyleKey = config.widgetStyle?.key else {
            fatalError("Unable to get widget style key. Aborting object creation.")
        }
        
        widget.widgetStyleKey = widgetStyleKey.rawValue
        
        let widgetImageUrl = FileManagerImagePersistenceController.shared.saveWidgetImage(
            image: widgetImage,
            for: widget.id
        )
        
        widget.previewImageUrl = widgetImageUrl
        
        for module in config.modules {
            let moduleImage = module.generateWidgetButtonImage()
            let persistentModule = PersistableModuleConfiguration.instantiateFromConfiguration(
                module,
                widgetId: widget.id,
                moduleImage: moduleImage,
                using: managedObjectContext
            )
            
            widget.modules = widget.modules.adding(persistentModule) as NSSet
        }
        
        widget.createdAt = .now
        
        do {
            try managedObjectContext.save()
            
            print("Widget \(widget.id) saved successfully.")
            return widget
            
        } catch {
            FileManagerImagePersistenceController.shared.deleteWidgetAndModules(with: widget.id)
            fatalError("Error creating widget persistent config: \(error.localizedDescription)")
        }
    }
}

extension PersistableWidgetConfiguration {
    static func basicFetchRequest() -> NSFetchRequest<PersistableWidgetConfiguration> {
        guard let request = PersistableWidgetConfiguration.fetchRequest()
                as? NSFetchRequest<PersistableWidgetConfiguration> else {
            fatalError("Could not create PersistableWidgetConfiguration fetch request.")
        }
        
        return request
    }
}
