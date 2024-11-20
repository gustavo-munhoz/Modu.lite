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
    public var shadowColorName: String?
    public var shadowOpacity: CGFloat?
    public var shadowOffset: CGSize?
    public var shadowBlurRadius: CGFloat?
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
        shadowColorName: String? = nil,
        shadowOpacity: CGFloat? = nil,
        shadowOffsetWidth: CGFloat? = nil,
        shadowOffsetHeight: CGFloat? = nil,
        shadowBlurRadius: CGFloat? = nil,
        textConfiguration: ModuleTextConfiguration,
        forcedUserInterfaceStyle: UIUserInterfaceStyle? = nil
    ) {
        self.identifier = identifier
        self.image = image
        self.filterColors = filterColors
        self.defaultColor = defaultColor
        self.imageBlendMode = imageBlendMode
        self.shadowColorName = shadowColorName
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = CGSize(
            width: shadowOffsetWidth ?? 0,
            height: shadowOffsetHeight ?? 0
        )
        self.shadowBlurRadius = shadowBlurRadius
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
            shadowColorName: data.shadowColorName,
            shadowOpacity: data.shadowOpacity,
            shadowOffsetWidth: data.shadowOffsetWidth,
            shadowOffsetHeight: data.shadowOffsetHeight,
            shadowBlurRadius: data.shadowBlurRadius,
            textConfiguration: ModuleTextConfiguration.create(from: data.textConfiguration),
            forcedUserInterfaceStyle: UIUserInterfaceStyle.fromString(data.forcedUserInterfaceStyle)
        )
    }
    
    // MARK: - Methods
    public func getFinalModuleImage(color: UIColor) -> UIImage {
        do {
            var finalImage = try blendedImage(with: color)
                        
            if let shadowColorName = shadowColorName,
               let shadowColor = UIColor.fromWidgetStyling(named: shadowColorName) {
                finalImage = applyShadow(
                    to: finalImage,
                    shadowColor: shadowColor
                )
            }
            
            return finalImage
        } catch {
            var imageToReturn = imageWithForcedTraitIfNeeded()
                        
            if let shadowColorName = shadowColorName,
               let shadowColor = UIColor.fromWidgetStyling(named: shadowColorName) {
                imageToReturn = applyShadow(
                    to: imageToReturn,
                    shadowColor: shadowColor
                )
            }
            
            return imageToReturn
        }
    }
    
    public func blendedImage(with color: UIColor) throws -> UIImage {
        guard let imageBlendMode = imageBlendMode else { throw ModuleError.undefinedBlendMode }
        
        let imageToBlend = imageWithForcedTraitIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: imageToBlend.size)
        let blendedImage = renderer.image { context in
            imageToBlend.draw(in: CGRect(origin: .zero, size: imageToBlend.size))
            context.cgContext.setBlendMode(imageBlendMode)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: imageToBlend.size))
        }
        
        return blendedImage
    }
    
    public func imageWithForcedTraitIfNeeded() -> UIImage {
        guard let forcedStyle = forcedUserInterfaceStyle else { return image }
        return image.withConfiguration(
            UIImage.Configuration(
                traitCollection: UITraitCollection(userInterfaceStyle: forcedStyle)
            )
        )
    }
    
    private func applyShadow(to image: UIImage, shadowColor: UIColor) -> UIImage {
        let shadowOpacity = Float(self.shadowOpacity ?? 1.0)
        let shadowOffset = self.shadowOffset ?? CGSize(width: 0, height: 0)
        let shadowBlurRadius = self.shadowBlurRadius ?? 5.0

        let imageSize = image.size

        // Cria um renderer com o tamanho original da imagem
        let renderer = UIGraphicsImageRenderer(size: imageSize)

        let imageWithShadow = renderer.image { context in
            let cgContext = context.cgContext

            // Salva o estado atual do contexto
            cgContext.saveGState()

            // Configura a sombra
            cgContext.setShadow(
                offset: shadowOffset,
                blur: shadowBlurRadius,
                color: shadowColor.withAlphaComponent(CGFloat(shadowOpacity)).cgColor
            )

            // Desenha a imagem com a sombra
            cgContext.beginTransparencyLayer(auxiliaryInfo: nil)
            image.draw(in: CGRect(origin: .zero, size: imageSize))
            cgContext.endTransparencyLayer()

            // Restaura o estado do contexto
            cgContext.restoreGState()
        }

        return imageWithShadow
    }

}
