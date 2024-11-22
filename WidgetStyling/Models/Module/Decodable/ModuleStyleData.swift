//
//  ModuleStyleData.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import Foundation

struct ModuleStyleData: Decodable {
    let identifier: String
    let imageName: String
    let filterColorNames: [String]
    let defaultColorName: String
    let imageBlendMode: String?
    let shadowColorName: String?
    let shadowOpacity: CGFloat?
    let shadowOffsetWidth: CGFloat?
    let shadowOffsetHeight: CGFloat?
    let shadowBlurRadius: CGFloat?
    let textConfiguration: ModuleTextConfigurationData
    let forcedUserInterfaceStyle: String?
}
