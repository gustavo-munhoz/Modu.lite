//
//  WidgetStyle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

enum WidgetStyleKey: String, Codable {
    case analog
    case tapedeck
}

class WidgetStyle {
    // MARK: - Properties
    let key: WidgetStyleKey
    var name: String
    var coverImage: UIImage
    var backgroundImage: UIImage?
    var styles: [ModuleStyle]
    var emptyModuleStyle: ModuleStyle?
    var colors: [UIColor]
    var textConfiguration: ModuleAppNameTextConfiguration

    // MARK: - Initalizers
    init(
        key: WidgetStyleKey,
        name: String,
        coverImage: UIImage,
        backgroundImage: UIImage?,
        styles: [ModuleStyle] = [],
        emptyModuleStyle: ModuleStyle? = nil,
        colors: [UIColor] = [],
        textConfiguration: ModuleAppNameTextConfiguration
    ) {
        self.key = key
        self.name = name
        self.coverImage = coverImage
        self.backgroundImage = backgroundImage
        self.styles = styles
        self.emptyModuleStyle = emptyModuleStyle
        self.colors = colors
        self.textConfiguration = textConfiguration
    }
    
    // MARK: - Setters
    
    func setModuleStyles(to styles: [ModuleStyle]) {
        self.styles = styles
    }
    
    func setEmptyStyle(to style: ModuleStyle) {
        self.emptyModuleStyle = style
    }
    
    // MARK: - Helper methods
    
    func getRandomStyle() -> ModuleStyle {
        guard !styles.isEmpty else {
            fatalError("Tried to get random styles but styles is empty.")
        }
        
        return styles.randomElement()!
    }
}

// MARK: - Equatable
extension WidgetStyle: Equatable {
    static func == (lhs: WidgetStyle, rhs: WidgetStyle) -> Bool {
        lhs.name == rhs.name
    }
}
