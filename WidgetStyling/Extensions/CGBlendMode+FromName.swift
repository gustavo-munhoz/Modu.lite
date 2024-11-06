//
//  CGBlendMode+FromName.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import CoreGraphics

extension CGBlendMode {
    static func named(_ name: String) -> CGBlendMode? {
        let blendModes: [String: CGBlendMode] = [
            "normal": .normal,
            "multiply": .multiply,
            "screen": .screen,
            "overlay": .overlay,
            "darken": .darken,
            "lighten": .lighten,
            "colorDodge": .colorDodge,
            "colorBurn": .colorBurn,
            "softLight": .softLight,
            "hardLight": .hardLight,
            "difference": .difference,
            "exclusion": .exclusion,
            "hue": .hue,
            "saturation": .saturation,
            "color": .color,
            "luminosity": .luminosity,
            "clear": .clear,
            "copy": .copy,
            "sourceIn": .sourceIn,
            "sourceOut": .sourceOut,
            "sourceAtop": .sourceAtop,
            "destinationOver": .destinationOver,
            "destinationIn": .destinationIn,
            "destinationOut": .destinationOut,
            "destinationAtop": .destinationAtop,
            "xor": .xor,
            "plusDarker": .plusDarker,
            "plusLighter": .plusLighter
        ]
        
        return blendModes[name.lowercased()]
    }
}
