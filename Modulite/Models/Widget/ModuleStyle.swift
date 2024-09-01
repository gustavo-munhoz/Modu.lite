//
//  ModuleStyle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/08/24.
//

import UIKit
import SwiftData

/// Represents the style of a module, allowing the choice from multiple styles.
class ModuleStyle {
    let id = UUID()
    unowned var widgetStyle: WidgetStyle
    let key: ModuleStyleKey
    var image: UIImage
    
    /// Initializes a new style with an optional image.
//    init(from style: WidgetStyle, imageName: String) {
//        self.widgetStyle = style
//        self.image = UIImage(named: imageName)!
//    }
    
    init(from style: WidgetStyle, key: ModuleStyleKey) {
        self.widgetStyle = style
        self.key = key
        self.image = key.getModuleImage()
    }
}

enum ModuleStyleKey: String, Codable {
    case analogEmpty = "analog-empty"
    case analogKnob = "analog-knob"
    case analogRegular = "analog-regular"
    case analogScreen = "analog-screen"
    case analogSound = "analog-sound"
    case analogSwitch = "analog-switch"
    
    func getModuleImage() -> UIImage {
        UIImage(named: self.rawValue)!
    }
}
