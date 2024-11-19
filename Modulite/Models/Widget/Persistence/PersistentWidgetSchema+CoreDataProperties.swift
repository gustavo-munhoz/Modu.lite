//
//  PersistentWidgetSchema+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/11/24.
//

import CoreData
import UIKit
import WidgetStyling

extension PersistentWidgetSchema {
    @NSManaged var id: UUID
    @NSManaged var type: String
    @NSManaged var name: String?
    @NSManaged var previewImageUrl: URL
    @NSManaged var styleIdentifier: String
    @NSManaged var modules: NSSet
    @NSManaged var lastEditedAt: Date
}

extension PersistentWidgetSchema {
    @discardableResult
    static func from(
        schema: WidgetSchema,
        widgetImage: UIImage,
        moduleImages: [Int: UIImage],
        using managedObjectContext: NSManagedObjectContext
    ) -> PersistentWidgetSchema {
        let persistedSchema = PersistentWidgetSchema(context: managedObjectContext)
        
        persistedSchema.id = schema.id
        persistedSchema.type = schema.type.rawValue
        persistedSchema.name = schema.name
        persistedSchema.styleIdentifier = schema.widgetStyle.identifier
        
        let widgetImageURL = FileManagerImagePersistenceController.shared.saveWidgetImage(
            image: widgetImage,
            for: persistedSchema.id
        )
        
        persistedSchema.previewImageUrl = widgetImageURL
        
        for module in schema.modules {
            guard let image = moduleImages[module.position] else {
                fatalError("Fatal error: module image not found.")
            }
            
            let imageURL = FileManagerImagePersistenceController.shared.saveModuleImage(
                image: image,
                for: schema.id,
                moduleIndex: module.position
            )
            
            let persistentModule = PersistentWidgetModule.from(
                module: module,
                imageURL: imageURL,
                schema: schema,
                using: managedObjectContext
            )
            
            persistedSchema.modules = persistedSchema.modules.adding(persistentModule) as NSSet
        }
        
        persistedSchema.lastEditedAt = .now
        
        do {
            try managedObjectContext.save()
            
            print("Schema \(persistedSchema.id) saved successfully.")
            return persistedSchema
            
        } catch {
            FileManagerImagePersistenceController.shared.deleteWidgetAndModules(
                widgetId: persistedSchema.id
            )
            fatalError("Error creating widget schema: \(error.localizedDescription)")
        }
    }
}

extension PersistentWidgetSchema {
    static func basicFetchRequest() -> NSFetchRequest<PersistentWidgetSchema> {
        guard let request = PersistentWidgetSchema.fetchRequest()
                as? NSFetchRequest<PersistentWidgetSchema> else {
            fatalError("Could not create PersistentWidgetSchema fetch request.")
        }
        
        return request
    }
}
