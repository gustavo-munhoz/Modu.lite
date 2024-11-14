//
//  PreviewSet.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

public struct PreviewSet {
    let mainWidgetPreview: UIImage
    let auxWidgetPreview: UIImage
    let wallpaperPreview1: UIImage
    let wallpaperPreview2: UIImage
    let wallpaperPreview3: UIImage
    
    enum PreviewError: Swift.Error, LocalizedError {
        case imageNotFound
        
        var errorDescription: String? {
            return "The requested preview image could not be found."
        }
    }
    
    static func create(from data: PreviewSetData) throws -> PreviewSet {
        guard let mainWidgetPreview = UIImage.fromWidgetStyling(named: data.mainWidgetPreview),
              let auxWidgetPreview = UIImage.fromWidgetStyling(named: data.auxWidgetPreview),
              let wallpaperPreview1 = UIImage.fromWidgetStyling(named: data.wallpaperPreview1Name),
              let wallpaperPreview2 = UIImage.fromWidgetStyling(named: data.wallpaperPreview2Name),
              let wallpaperPreview3 = UIImage.fromWidgetStyling(named: data.wallpaperPreview3Name)
        else {
            throw PreviewError.imageNotFound
        }
        
        return PreviewSet(
            mainWidgetPreview: mainWidgetPreview,
            auxWidgetPreview: auxWidgetPreview,
            wallpaperPreview1: wallpaperPreview1,
            wallpaperPreview2: wallpaperPreview2,
            wallpaperPreview3: wallpaperPreview3
        )
    }
}
