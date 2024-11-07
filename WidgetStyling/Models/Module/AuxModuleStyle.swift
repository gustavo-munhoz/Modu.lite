//
//  AuxModuleStyle.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class AuxModuleStyle: ModuleStyle {
    // MARK: - Properties
    public var identifier: String
    public var image: UIImage
    public var filterColors: [UIColor]
    public var defaultColor: UIColor
    public var imageBlendMode: CGBlendMode?
    public var textConfiguration: ModuleTextConfiguration
    
    enum ModuleError: Swift.Error {
        case imageNotFound
        case colorNotFound
        case undefinedBlendMode
    }
    
    // MARK: - Initializers
    init(
        identifier: String,
        image: UIImage,
        filterColors: [UIColor],
        defaultColor: UIColor,
        imageBlendMode: CGBlendMode? = nil,
        textConfiguration: ModuleTextConfiguration
    ) {
        self.identifier = identifier
        self.image = image
        self.filterColors = filterColors
        self.defaultColor = defaultColor
        self.imageBlendMode = imageBlendMode
        self.textConfiguration = textConfiguration
    }
    
    convenience init(from data: ModuleStyleData) throws {
        guard let image = UIImage.fromWidgetStyling(named: data.imageName) else {
            throw ModuleError.imageNotFound
        }
        
        var filterColors: [UIColor] = []
        for color in data.filterColorNames {
            guard let color = UIColor.fromWidgetStyling(named: color) else {
                throw ModuleError.colorNotFound
            }
            
            filterColors.append(color)
        }
        
        guard let defaultColor = UIColor.fromWidgetStyling(named: data.defaultColorName) else {
            throw ModuleError.colorNotFound
        }
        
        self.init(
            identifier: data.identifier,
            image: image,
            filterColors: filterColors,
            defaultColor: defaultColor,
            imageBlendMode: .named(data.imageBlendMode ?? ""),
            textConfiguration: .create(from: data.textConfiguration)
        )
    }
    
    // MARK: - Methods
    public func blendedImage(with color: UIColor) throws -> UIImage {
        guard let imageBlendMode else { throw ModuleError.undefinedBlendMode }
        
        let image = image.withConfiguration(
            UIImage.Configuration(traitCollection: .init(userInterfaceStyle: .light))
        )
        
        let renderer = UIGraphicsImageRenderer(size: image.size, format: image.imageRendererFormat)
        
        let blendedImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            context.cgContext.setBlendMode(imageBlendMode)
            context.cgContext.setFillColor(color.cgColor)
            
            let rect = CGRect(origin: .zero, size: image.size)
            context.cgContext.fill(rect)
        }
        
        return blendedImage
    }
}
