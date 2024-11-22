//
//  StyleModuleConfigurationData.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import Foundation

struct StyleModuleConfigurationData: Decodable {
    let mainModules: [ModuleStyleData]
    let mainEmptyModule: ModuleStyleData
    let auxModules: [ModuleStyleData]
    let auxEmptyModule: ModuleStyleData
}
