//
//  MainWidgetConfigurationEntity.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import AppIntents
import CoreData

struct MainWidgetConfigurationEntity: AppEntity {
    var id: UUID
    var name: String
    
    // TODO: Use default localizable key pattern
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Main Widget Configuration"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)"
        )
    }
    
    static var defaultQuery = MainWidgetConfigurationQuery()
}
