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
            "colordodge": .colorDodge,
            "colorburn": .colorBurn,
            "softlight": .softLight,
            "hardlight": .hardLight,
            "difference": .difference,
            "exclusion": .exclusion,
            "hue": .hue,
            "saturation": .saturation,
            "color": .color,
            "luminosity": .luminosity,
            "clear": .clear,
            "copy": .copy,
            "sourcein": .sourceIn,
            "sourceout": .sourceOut,
            "sourceatop": .sourceAtop,
            "destinationover": .destinationOver,
            "destinationin": .destinationIn,
            "destinationout": .destinationOut,
            "destinationatop": .destinationAtop,
            "xor": .xor,
            "plusdarker": .plusDarker,
            "pluslighter": .plusLighter
        ]
        
        return blendModes[name.lowercased()]
    }
}
