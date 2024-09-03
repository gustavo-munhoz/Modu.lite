//
//  PersistableWidgetConfiguration+CoreDataProperties.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 02/09/24.
//
//

import CoreData

extension PersistableWidgetConfiguration {
    @NSManaged var name: String
    @NSManaged var resultingImageURL: URL
    @NSManaged var widgetStyleKey: String
    @NSManaged var modules: [PersistableModuleConfiguration]
}
