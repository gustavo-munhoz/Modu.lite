//
//  BaseModuleStyle.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 18/11/24.
//

import UIKit

public class BaseModuleStyle: ModuleStyle {
    // MARK: - Properties
    public var identifier: String
    public var image: UIImage
    public var filterColors: [UIColor]
    public var defaultColor: UIColor
    public var imageBlendMode: CGBlendMode?
    public var textConfiguration: ModuleTextConfiguration
    public var forcedUserInterfaceStyle: UIUserInterfaceStyle?
    
    enum ModuleError: Swift.Error, LocalizedError {
        case imageNotFound
        case colorNotFound
        case undefinedBlendMode
        
        var errorDescription: String? {
            return switch self {
            case .imageNotFound:
                "The requested image for the module could not be found."
            case .colorNotFound:
                "The specified color for the module could not be found."
            case .undefinedBlendMode:
                "The blend mode for the module is undefined."
            }
        }
    }
    
    // MARK: - Initializers
    public init(
        identifier: String,
        image: UIImage,
        filterColors: [UIColor],
        defaultColor: UIColor,
        imageBlendMode: CGBlendMode? = nil,
        textConfiguration: ModuleTextConfiguration,
        forcedUserInterfaceStyle: UIUserInterfaceStyle? = nil
    ) {
        self.identifier = identifier
        self.image = image
        self.filterColors = filterColors
        self.defaultColor = defaultColor
        self.imageBlendMode = imageBlendMode
        self.textConfiguration = textConfiguration
        self.forcedUserInterfaceStyle = forcedUserInterfaceStyle
    }
    
    convenience init(from data: ModuleStyleData) throws {
        guard let image = UIImage.fromWidgetStyling(named: data.imageName) else {
            throw ModuleError.imageNotFound
        }
        
        var filterColors: [UIColor] = []
        for colorName in data.filterColorNames {
            guard let color = UIColor.fromWidgetStyling(named: colorName) else {
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
            imageBlendMode: CGBlendMode.named(data.imageBlendMode ?? ""),
            textConfiguration: ModuleTextConfiguration.create(from: data.textConfiguration),
            forcedUserInterfaceStyle: UIUserInterfaceStyle.fromString(data.forcedUserInterfaceStyle)
        )
    }
    
    // MARK: - Methods
    public func blendedImage(with color: UIColor) throws -> UIImage {
        guard let imageBlendMode = imageBlendMode else { throw ModuleError.undefinedBlendMode }
        
        var imageToBlend = image
        if let forcedStyle = forcedUserInterfaceStyle {
            imageToBlend = imageToBlend.withConfiguration(
                UIImage.Configuration(
                    traitCollection: UITraitCollection(userInterfaceStyle: forcedStyle)
                )
            )
        }
        
        let renderer = UIGraphicsImageRenderer(size: imageToBlend.size)
        let blendedImage = renderer.image { context in
            imageToBlend.draw(in: CGRect(origin: .zero, size: imageToBlend.size))
            context.cgContext.setBlendMode(imageBlendMode)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: imageToBlend.size))
        }
        
        return blendedImage
    }
    
    public func getFinalModuleImage(color: UIColor) -> UIImage {
        do {
            return try blendedImage(with: color)
        } catch {
            return imageWithForcedTraitIfNeeded()
        }
    }
    
    public func imageWithForcedTraitIfNeeded() -> UIImage {
        guard let forcedStyle = forcedUserInterfaceStyle else { return image }
        return image.withConfiguration(
            UIImage.Configuration(
                traitCollection: UITraitCollection(userInterfaceStyle: forcedStyle)
            )
        )
    }
}
