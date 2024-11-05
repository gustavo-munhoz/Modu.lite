//
//  WidgetStyle.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public protocol WidgetStyle {
    var identifier: String { get }
    var name: String { get }
    var preview: UIImage { get }
    var backgroundConfiguration: WidgetBackgroundConfiguration { get }
    var moduleConfiguration: WidgetModuleConfiguration { get }
    var wallpaperConfiguration: WidgetWallpaperConfiguration { get }
}

public struct WidgetBackgroundConfiguration {
    let mainBackground: WidgetBackground
    let auxBackground: WidgetBackground
}

public struct WidgetModuleConfiguration {
    let mainModules: [MainModuleStyle]
    let auxModules: [AuxModuleStyle]
}

public struct WidgetWallpaperConfiguration {
    let blockedScreenWallpaper: [UIImage]
    let homeScreenWallpaper: [UIImage]
}

enum WidgetBackground {
    case image(UIImage)
    case color(UIColor)
}
