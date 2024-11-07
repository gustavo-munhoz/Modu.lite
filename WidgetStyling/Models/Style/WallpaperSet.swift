//
//  WallpaperSet.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

public struct WallpaperSet {
    let blockScreen: UIImage
    let homeScreen: UIImage
    
    enum WallpaperError: Swift.Error {
        case imageNotFound
    }
    
    static func create(from data: WallpaperSetData) throws -> WallpaperSet {
        guard let blockImage = UIImage.fromWidgetStyling(named: data.blockedImageName),
              let homeImage = UIImage.fromWidgetStyling(named: data.homeImageName) else {
            throw WallpaperError.imageNotFound
        }
        
        return .init(blockScreen: blockImage, homeScreen: homeImage)
    }
}
