//
//  WidgetStyleFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

enum WidgetStyleKey {
    case analog
}

class WidgetStyleFactory {
    static func styleForKey(_ key: WidgetStyleKey) -> WidgetStyle {
        switch key {
        case .analog:
            return WidgetStyle(
                name: .localized(for: .widgetStyleNameAnalog),
                coverImage: UIImage(systemName: "house.fill")!, // FIXME: Implement this
                backgroundImage: nil,
                styles: [
                    ModuleStyle(imageName: "analog-regular"),
                    ModuleStyle(imageName: "analog-knob"),
                    ModuleStyle(imageName: "analog-screen"),
                    ModuleStyle(imageName: "analog-sound"),
                    ModuleStyle(imageName: "analog-switch")
                ],
                colors: [.white, .eggYolk, .cupcake, .sweetTooth, .sugarMint, .burntEnds]
            )
        }
    }
}
