//
//  AuxWidgetConfigurationEntity.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import AppIntents

struct AuxWidgetConfigurationEntity: AppEntity {
    var id: UUID
    var name: String
        
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Auxiliary Widget Configuration"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)"
        )
    }
    
    static var defaultQuery = AuxWidgetConfigurationQuery()
}
