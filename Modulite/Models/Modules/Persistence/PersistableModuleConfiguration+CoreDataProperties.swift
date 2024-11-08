//
//  PersistableModuleConfiguration+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//

import UIKit
import CoreData
import WidgetStyling

//extension PersistableModuleConfiguration {
//    @NSManaged var index: Int16
//    @NSManaged var appName: String?
//    @NSManaged var urlScheme: URL?
//    @NSManaged var selectedStyleKey: String
//    @NSManaged var selectedColor: UIColor?
//    @NSManaged var resultingImageURL: URL
//}
//
//extension PersistableModuleConfiguration {
//    static func instantiateFromConfiguration(
//        _ config: ModuleConfiguration,
//        widgetId: UUID,
//        moduleImage: UIImage,
//        using managedObjectContext: NSManagedObjectContext
//    ) -> PersistableModuleConfiguration {
//        let module = PersistableModuleConfiguration(context: managedObjectContext)
//        
//        module.index = Int16(config.index)
//        module.appName = config.appName
//        module.urlScheme = config.associatedURLScheme
//        module.selectedStyleKey = config.selectedStyle.key.rawValue
//        module.selectedColor = config.selectedColor
//        
//        let moduleImageUrl = FileManagerImagePersistenceController.shared.saveModuleImage(
//            image: moduleImage,
//            for: widgetId,
//            moduleIndex: config.index
//        )
//        
//        module.resultingImageURL = moduleImageUrl
//        
//        return module
//    }
//    
//    static func from(
//        module: WidgetModule,
//        widgetId: UUID,
//        using managedObjectContext: NSManagedObjectContext
//    ) -> PersistableModuleConfiguration {
//        let persistedModule = PersistableModuleConfiguration(context: managedObjectContext)
//        
//        persistedModule.index = Int16(module.position)
//        persistedModule.appName = module.appName
//        persistedModule.urlScheme = module.urlScheme
//        persistedModule.selectedStyleKey = module.style.identifier
//        persistedModule.selectedColor = module.color
//        
//        let moduleImage = module.createCompleteImage()
//        
//        let persistedModuleImageURL = FileManagerImagePersistenceController.shared.saveModuleImage(
//            image: moduleImage,
//            for: widgetId,
//            moduleIndex: module.position
//        )
//        
//        persistedModule.resultingImageURL = persistedModuleImageURL
//        
//        return persistedModule
//    }
//}
