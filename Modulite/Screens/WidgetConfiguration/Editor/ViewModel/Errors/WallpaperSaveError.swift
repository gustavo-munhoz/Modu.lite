//
//  WallpaperSaveError.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 25/10/24.
//

import Foundation

enum WallpaperSaveError: LocalizedError, LocalizedKeyProtocol {
    case unableToSaveWallpaper
    case photosAuthorizationDenied
    case saveFailed(Error)
    case wallpaperUnknownError
    
    var errorDescription: String? {
        .localized(for: self)
    }
}
