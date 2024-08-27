//
//  WidgetStyle.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/08/24.
//

import UIKit

class WidgetStyle {
    // MARK: - Properties
    var name: String
    var coverImage: UIImage
    var backgroundImage: UIImage?
    var styles: [ModuleStyle]
    var colors: [UIColor]
    var textConfiguration: ModuleAppNameTextConfiguration

    // MARK: - Initalizers
    init(
        name: String,
        coverImage: UIImage,
        backgroundImage: UIImage?,
        styles: [ModuleStyle] = [],
        colors: [UIColor] = [],
        textConfiguration: ModuleAppNameTextConfiguration
    ) {
        self.name = name
        self.coverImage = coverImage
        self.backgroundImage = backgroundImage
        self.styles = styles
        self.colors = colors
        self.textConfiguration = textConfiguration
    }
    
    // MARK: - Setters
    
    func setModuleStyles(to styles: [ModuleStyle]) {
        self.styles = styles
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
