//
//  LoadedWidgetStyle.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

class LoadedWidgetStyle: WidgetStyle {
    // MARK: - Properties
    var identifier: String
    var name: String
    var preview: UIImage
    var backgroundConfiguration: StyleBackgroundConfiguration
    var moduleConfiguration: StyleModuleConfiguration
    var wallpaperSet: WallpaperSet
    var isPurchased: Bool
    var isIncludedInPlus: Bool
    
    enum WidgetStyleError: Swift.Error {
        case previewNotFound
    }
    
    // MARK: - Initializers
    init(
        identifier: String,
        name: String,
        preview: UIImage,
        isPurchased: Bool,
        isIncludedInPlus: Bool,
        backgroundConfiguration: StyleBackgroundConfiguration,
        moduleConfiguration: StyleModuleConfiguration,
        wallpaperSet: WallpaperSet
    ) {
        self.identifier = identifier
        self.name = name
        self.preview = preview
        self.isPurchased = isPurchased
        self.isIncludedInPlus = isIncludedInPlus
        self.backgroundConfiguration = backgroundConfiguration
        self.moduleConfiguration = moduleConfiguration
        self.wallpaperSet = wallpaperSet
    }
    
    convenience init(from data: WidgetStyleData) throws {
        guard let previewImage = UIImage(named: data.previewImageName) else {
            throw WidgetStyleError.previewNotFound
        }
        
        self.init(
            identifier: data.identifier,
            name: data.name,
            preview: previewImage,
            isPurchased: data.isPurchased,
            isIncludedInPlus: data.isIncludedInPlus,
            backgroundConfiguration: try .create(from: data.backgroundConfiguration),
            moduleConfiguration: try .create(from: data.moduleConfiguration),
            wallpaperSet: try .create(from: data.wallpaperSet)
        )
    }
    
    // MARK: - Methods
    func getEmptyStyle(for type: WidgetType) -> ModuleStyle {
        switch type {
        case .main:
            return moduleConfiguration.mainEmptyModule
        case .auxiliary:
            return moduleConfiguration.auxEmptyModule
        }
    }
    
    func getRandomStyle(for type: WidgetType) -> ModuleStyle {
        let styles = getModuleStyles(for: type)
        return styles.randomElement() ?? getEmptyStyle(for: type)
    }
    
    func getModuleStyles(for type: WidgetType) -> [ModuleStyle] {
        switch type {
        case .main:
            return moduleConfiguration.mainModules
        case .auxiliary:
            return moduleConfiguration.auxModules
        }
    }
    
    func getBackground(for type: WidgetType) -> StyleBackground {
        switch type {
        case .main:
            return backgroundConfiguration.mainBackground
        case .auxiliary:
            return backgroundConfiguration.auxBackground
        }
    }
    
    func getWallpapers() -> WallpaperSet {
        WallpaperSet(
            blockScreen: wallpaperSet.blockScreen,
            homeScreen: wallpaperSet.homeScreen
        )
    }
}
