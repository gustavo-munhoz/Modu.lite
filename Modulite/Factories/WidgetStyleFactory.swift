//
//  WidgetStyleFactory.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit
import SwiftData

enum WidgetStyleKey: Codable {
    case analog
}

class WidgetStyleFactory {
    
    static func styleForKey(_ key: WidgetStyleKey) -> WidgetStyle {
        switch key {
        case .analog:
            let textConfig = ModuleAppNameTextConfiguration()
                .font(UIFont(textStyle: .caption2, weight: .semibold))
                .textColor(.iceCold)
                .shadow(color: .iceCold, blurRadius: 5)
                .textCase(.lower)
                .removingSpaces()
                .preffix(".")

            let style = WidgetStyle(
                name: .localized(for: .widgetStyleNameAnalog),
                coverImage: UIImage(systemName: "house.fill")!,
                // FIXME: Implement this
                backgroundImage: nil,
                colors: [.white, .eggYolk, .cupcake, .sweetTooth, .sugarMint, .burntEnds],
                textConfiguration: textConfig
            )
            
            let moduleStyles = [
                ModuleStyle(from: style, imageName: "analog-regular"),
                ModuleStyle(from: style, imageName: "analog-knob"),
                ModuleStyle(from: style, imageName: "analog-screen"),
                ModuleStyle(from: style, imageName: "analog-sound"),
                ModuleStyle(from: style, imageName: "analog-switch")
            ]
            
            style.setModuleStyles(to: moduleStyles)
            style.setEmptyStyle(to: ModuleStyle(from: style, imageName: "analog-empty"))
            
            return style
        }
    }
}
