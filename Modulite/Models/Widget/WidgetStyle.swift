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
    var previewImage: UIImage
    var background: WidgetBackground?
    var styles: [ModuleStyle]
    var emptyModuleStyle: ModuleStyle?
    var colors: [UIColor]
    var defaultColor: UIColor
    var textConfiguration: ModuleAppNameTextConfiguration
    var blockedScreenWallpaperImage: UIImage
    var homeScreenWallpaperImage: UIImage
    var imageBlendMode: CGBlendMode?
    var isPurchased: Bool = false
    var isGrantedByPlus: Bool = false
    
    // MARK: - Initalizers
    init(
        key: WidgetStyleKey,
        name: String,
        previewImage: UIImage,
        background: WidgetBackground?,
        styles: [ModuleStyle] = [],
        emptyModuleStyle: ModuleStyle? = nil,
        colors: [UIColor],
        defaultColor: UIColor,
        textConfiguration: ModuleAppNameTextConfiguration,
        blockedScreenWallpaperImage: UIImage,
        homeScreenWallpaperImage: UIImage,
        imageBlendMode: CGBlendMode? = nil
    ) {
        self.key = key
        self.name = name
        self.previewImage = previewImage
        self.background = background
        self.styles = styles
        self.emptyModuleStyle = emptyModuleStyle
        self.colors = colors
        self.defaultColor = defaultColor
        self.textConfiguration = textConfiguration
        self.blockedScreenWallpaperImage = blockedScreenWallpaperImage
        self.homeScreenWallpaperImage = homeScreenWallpaperImage
        self.imageBlendMode = imageBlendMode
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
