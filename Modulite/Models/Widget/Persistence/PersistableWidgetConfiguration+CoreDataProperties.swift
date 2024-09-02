//
//  PersistableWidgetConfiguration+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//
//

import Foundation
import CoreData


extension PersistableWidgetConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistableWidgetConfiguration> {
        return NSFetchRequest<PersistableWidgetConfiguration>(entityName: "PersistableWidgetConfiguration")
    }

    @NSManaged public var name: String?
    @NSManaged public var resultingImageURL: URL?
    @NSManaged public var widgetStyleKey: String?
    @NSManaged public var modules: NSSet?

}

// MARK: Generated accessors for modules
extension PersistableWidgetConfiguration {

    @objc(addModulesObject:)
    @NSManaged public func addToModules(_ value: PersistableModuleConfiguration)

    @objc(removeModulesObject:)
    @NSManaged public func removeFromModules(_ value: PersistableModuleConfiguration)

    @objc(addModules:)
    @NSManaged public func addToModules(_ values: NSSet)

    @objc(removeModules:)
    @NSManaged public func removeFromModules(_ values: NSSet)

}

extension PersistableWidgetConfiguration : Identifiable {

}
