//
//  PersistableModuleConfiguration+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import UIKit
import CoreData

extension PersistableModuleConfiguration {
    @NSManaged var index: Int16
    @NSManaged var appName: String?
    @NSManaged var urlScheme: URL?
    @NSManaged var selectedStyleKey: String
    @NSManaged var selectedColor: UIColor?
    @NSManaged var resultingImageURL: URL
}

extension PersistableModuleConfiguration {
    static func instantiateFromConfiguration(
        _ config: ModuleConfiguration,
        widgetId: UUID,
        moduleImage: UIImage,
        using managedObjectContext: NSManagedObjectContext
    ) -> PersistableModuleConfiguration {
        let module = PersistableModuleConfiguration(context: managedObjectContext)
        
        module.index = Int16(config.index)
        module.appName = config.appName
        module.urlScheme = config.associatedURLScheme
        module.selectedStyleKey = config.selectedStyle.key.rawValue
        module.selectedColor = config.selectedColor
        
        let moduleImageUrl = FileManagerImagePersistenceController.shared.saveModuleImage(
            image: moduleImage,
            for: widgetId,
            moduleIndex: config.index
        )
        
        module.resultingImageURL = moduleImageUrl
        
        return module
    }
}
