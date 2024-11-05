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
    public let mainBackground: WidgetBackground { get }
    public let auxBackground: WidgetBackground { get }
}

public struct WidgetModuleConfiguration {
    public let mainModules: [MainModuleStyle] { get }
    public let auxModules: [AuxModuleStyle] { get }
}

public struct WidgetWallpaperConfiguration {
    public let blockedScreenWallpaper: [UIImage] { get }
    public let homeScreenWallpaper: [UIImage] { get }
}

enum WidgetBackground {
    case image(UIImage)
    case color(UIColor)
}
