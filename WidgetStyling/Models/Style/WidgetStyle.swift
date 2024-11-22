//
//  WidgetStyle.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public protocol WidgetStyle: AnyObject {
    var identifier: String { get }
    var name: String { get }
    var previewSet: PreviewSet { get }
    var backgroundConfiguration: StyleBackgroundConfiguration { get }
    var moduleConfiguration: StyleModuleConfiguration { get }
    var wallpaperSet: WallpaperSet { get }
    var isPurchased: Bool { get set }
    var isIncludedInPlus: Bool { get }
    
    func getEmptyModuleStyle(for type: WidgetType) -> ModuleStyle
    func getRandomModuleStyle(for type: WidgetType) -> ModuleStyle
    func getModuleStyles(for type: WidgetType) -> [ModuleStyle]
    func getBackground(for type: WidgetType) -> StyleBackground
    func getWallpapers() -> WallpaperSet
    func getWidgetPreview(for type: WidgetType) -> UIImage
    func getWallpaperPreviewImages() -> [UIImage]
    
    func isEqual(to other: WidgetStyle) -> Bool
    
    func updateIsPurchased(to value: Bool)
}

extension WidgetStyle {
    func isEqual(to other: WidgetStyle) -> Bool {
        identifier == other.identifier
    }
    
    func updateIsPurchased(to value: Bool) {
        isPurchased = value
    }
}
