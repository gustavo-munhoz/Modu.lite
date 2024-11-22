//
//  MainWidgetConfigurationData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/09/24.
//

import Foundation
import WidgetStyling

struct MainWidgetConfigurationData {
    let id: UUID
    let name: String
    let background: StyleBackground
    let modules: [MainWidgetModuleData]
}
