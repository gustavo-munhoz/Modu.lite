//
//  ModuleTextConfigurationData.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

struct ModuleTextConfigurationData: Decodable {
    // MARK: - Properties
    let fontName: String?
    let fontSize: CGFloat?
    let fontWeight: String?
    let textColorName: String?
    let textAlignment: String?
    let shadowColorName: String?
    let shadowOffsetWidth: CGFloat?
    let shadowOffsetHeight: CGFloat?
    let shadowBlurRadius: CGFloat?
    let letterSpacing: CGFloat?
    let textCase: String?
    let shouldRemoveSpaces: Bool?
    let prefix: String?
    let suffix: String?
    let bottomRelativePosition: CGFloat?
}
