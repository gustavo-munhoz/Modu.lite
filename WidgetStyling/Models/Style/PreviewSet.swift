//
//  PreviewSet.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import UIKit

public struct PreviewSet {
    let widgetPreview: UIImage
    let wallpaperPreview1: UIImage
    let wallpaperPreview2: UIImage
    let wallpaperPreview3: UIImage
    
    enum PreviewError: Swift.Error {
        case imageNotFound
    }
    
    static func create(from data: PreviewSetData) throws -> PreviewSet {
        guard let widgetPreview = UIImage.fromWidgetStyling(named: data.widgetPreviewName),
              let wallpaperPreview1 = UIImage.fromWidgetStyling(named: data.wallpaperPreview1Name),
              let wallpaperPreview2 = UIImage.fromWidgetStyling(named: data.wallpaperPreview2Name),
              let wallpaperPreview3 = UIImage.fromWidgetStyling(named: data.wallpaperPreview3Name)
        else {
            throw PreviewError.imageNotFound
        }
        
        return PreviewSet(
            widgetPreview: widgetPreview,
            wallpaperPreview1: wallpaperPreview1,
            wallpaperPreview2: wallpaperPreview2,
            wallpaperPreview3: wallpaperPreview3
        )
    }
}
