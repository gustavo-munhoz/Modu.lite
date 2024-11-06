//
//  StyleBackgroundConfigurationData.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import Foundation

struct StyleBackgroundConfigurationData: Decodable {
    let mainBackground: StyleBackgroundData
    let auxBackground: StyleBackgroundData
}

struct StyleBackgroundData: Decodable {
    let type: String
    let value: String
}
