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
        case imageNotFound(previewName: String)
        
        var errorDescription: String? {
            switch self {
            case .imageNotFound(let previewName):
                return "The requested preview image '\(previewName)' could not be found."
            }
        }
    }
    
    static func create(from data: PreviewSetData) throws -> PreviewSet {
        guard let mainWidgetPreview = UIImage.fromWidgetStyling(named: data.mainWidgetPreview) else {
            throw PreviewError.imageNotFound(previewName: data.mainWidgetPreview)
        }
        
        guard let auxWidgetPreview = UIImage.fromWidgetStyling(named: data.auxWidgetPreview) else {
            throw PreviewError.imageNotFound(previewName: data.auxWidgetPreview)
        }
        
        guard let wallpaperPreview1 = UIImage.fromWidgetStyling(named: data.wallpaperPreview1Name) else {
            throw PreviewError.imageNotFound(previewName: data.wallpaperPreview1Name)
        }
        
        guard let wallpaperPreview2 = UIImage.fromWidgetStyling(named: data.wallpaperPreview2Name) else {
            throw PreviewError.imageNotFound(previewName: data.wallpaperPreview2Name)
        }
        
        guard let wallpaperPreview3 = UIImage.fromWidgetStyling(named: data.wallpaperPreview3Name) else {
            throw PreviewError.imageNotFound(previewName: data.wallpaperPreview3Name)
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
