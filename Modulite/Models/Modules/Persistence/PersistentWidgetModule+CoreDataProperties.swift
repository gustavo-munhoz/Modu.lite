//
//  PersistentWidgetModule+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/11/24.
//

import CoreData
import UIKit
import WidgetStyling

extension PersistentWidgetModule {
    @NSManaged var position: Int16
    @NSManaged var appName: String?
    @NSManaged var urlScheme: URL?
    @NSManaged var styleIdentifier: String
    @NSManaged var selectedColor: UIColor
    @NSManaged var imageURL: URL
}

extension PersistentWidgetModule {
    static func from(
        module: WidgetModule,
        schema: WidgetSchema,
        using managedObjectContext: NSManagedObjectContext
    ) -> PersistentWidgetModule {
        let persistedModule = PersistentWidgetModule(context: managedObjectContext)
        
        persistedModule.position = Int16(module.position)
        persistedModule.appName = module.appName
        persistedModule.urlScheme = module.urlScheme
        persistedModule.styleIdentifier = module.style.identifier
        persistedModule.selectedColor = module.color
        
        let strategy: WidgetTypeStrategy = if schema.type == .main {
            MainWidgetStrategy()
        } else {
            AuxWidgetStrategy()
        }
        
        let moduleImage = module.createCompleteImage(
            for: strategy
        )
        
        let persistedModuleImageURL = FileManagerImagePersistenceController.shared.saveModuleImage(
            image: moduleImage,
            for: schema.id,
            moduleIndex: module.position
        )
        
        persistedModule.imageURL = persistedModuleImageURL
        
        return persistedModule
    }
}

extension PersistentWidgetModule {
    static func basicFetchRequest() -> NSFetchRequest<PersistentWidgetModule> {
        guard let request = PersistentWidgetModule.fetchRequest()
                as? NSFetchRequest<PersistentWidgetModule> else {
            fatalError("Could not create PersistentWidgetModule fetch request.")
        }
        
        return request
    }
}
