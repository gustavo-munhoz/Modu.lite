//
//  ModuleStyle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 29/08/24.
//

import UIKit

/// Represents the style of a module, allowing the choice from multiple styles.
class ModuleStyle {
    let id = UUID()
    unowned var widgetStyle: WidgetStyle
    let key: ModuleStyleKey
    var image: UIImage
    
    init(from style: WidgetStyle, key: ModuleStyleKey) {
        self.widgetStyle = style
        self.key = key
        self.image = key.getModuleImage()
    }
}

enum ModuleStyleKey: String, Codable {
    // MARK: - Analog -
    case analogEmpty
    case analogKnob
    case analogRegular
    case analogScreen
    case analogSound
    case analogSwitch
    
    // MARK: - Tapedeck -
    case tapedeckMainSound
    case tapedeckMainSlider
    case tapedeckMainSelector
    case tapedeckMainPower
    case tapedeckMainEmpty
    case tapedeckMain8seg
    case tapedeckAuxInput
    case tapedeckAuxButton
    case tapedeckAuxBlueButton
    
    func getModuleImage() -> UIImage {
        UIImage(named: rawValue)!
    }
}
