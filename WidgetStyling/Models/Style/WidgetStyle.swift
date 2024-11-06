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
    var previewSet: PreviewSet { get }
    var backgroundConfiguration: StyleBackgroundConfiguration { get }
    var moduleConfiguration: StyleModuleConfiguration { get }
    var wallpaperSet: WallpaperSet { get }
    var isPurchased: Bool { get }
    var isIncludedInPlus: Bool { get }
    
    func getEmptyStyle(for type: WidgetType) -> ModuleStyle
    func getRandomStyle(for type: WidgetType) -> ModuleStyle
    func getModuleStyles(for type: WidgetType) -> [ModuleStyle]
    func getBackground(for type: WidgetType) -> StyleBackground
    func getWallpapers() -> WallpaperSet
}
