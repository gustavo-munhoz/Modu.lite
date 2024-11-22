//
//  AuxWidgetConfigurationData.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import Foundation
import WidgetStyling

struct AuxWidgetConfigurationData {
    let id: UUID
    let name: String
    let background: StyleBackground
    let modules: [AuxWidgetModuleData]
}
