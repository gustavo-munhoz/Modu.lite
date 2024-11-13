//
//  StyleBackgroundConfiguration.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public enum StyleBackground {
    case image(UIImage)
    case color(UIColor)
    
    enum BackgroundError: Swift.Error {
        case imageNotFound
        case colorNotFound
        case invalidType
    }
    
    static func create(from data: StyleBackgroundData) throws -> StyleBackground {
        switch data.type.lowercased() {
        case "image":
            guard let image = UIImage.fromWidgetStyling(named: data.value) else {
                throw BackgroundError.imageNotFound
            }
            return .image(image)
            
        case "color":
            guard let color = UIColor.fromWidgetStyling(named: data.value) else {
                print("color not found: \(data.value)")
                throw BackgroundError.colorNotFound
            }
            return .color(color)
            
        default: throw BackgroundError.invalidType
        }
    }
}

public struct StyleBackgroundConfiguration {
    let mainBackground: StyleBackground
    let auxBackground: StyleBackground
    
    static func create(
        from data: StyleBackgroundConfigurationData
    ) throws -> StyleBackgroundConfiguration {
        StyleBackgroundConfiguration(
            mainBackground: try .create(from: data.mainBackground),
            auxBackground: try .create(from: data.auxBackground)
        )
    }
}
