//
//  StyleModuleConfiguration.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

public struct StyleModuleConfiguration {
    let mainModules: [MainModuleStyle]
    let mainEmptyModule: MainModuleStyle
    
    let auxModules: [AuxModuleStyle]
    let auxEmptyModule: AuxModuleStyle
    
    static func create(from data: StyleModuleConfigurationData) throws -> StyleModuleConfiguration {
        let mainModules = try data.mainModules.map { try MainModuleStyle(from: $0) }
        let auxModules = try data.auxModules.map { try AuxModuleStyle(from: $0) }
        
        return StyleModuleConfiguration(
            mainModules: mainModules,
            mainEmptyModule: try MainModuleStyle(from: data.mainEmptyModule),
            auxModules: auxModules,
            auxEmptyModule: try AuxModuleStyle(from: data.auxEmptyModule)
        )
    }
}
