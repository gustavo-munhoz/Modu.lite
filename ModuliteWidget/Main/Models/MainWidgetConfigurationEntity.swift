//
//  MainWidgetConfigurationEntity.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import AppIntents

struct MainWidgetConfigurationEntity: AppEntity {
    var id: UUID
    var name: String
        
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Main Widget Configuration"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)"
        )
    }
    
    static var defaultQuery = MainWidgetConfigurationQuery()
}
