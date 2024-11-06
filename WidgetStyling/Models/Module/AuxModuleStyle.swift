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
        guard let image = UIImage(named: data.imageName) else {
            throw ModuleError.imageNotFound
        }
        
        var filterColors: [UIColor] = []
        for color in data.filterColorNames {
            guard let color = UIColor(named: color) else {
                throw ModuleError.colorNotFound
            }
            
            filterColors.append(color)
        }
        
        guard let defaultColor = UIColor(named: data.defaultColorName) else {
            throw ModuleError.colorNotFound
        }
        
        self.init(
            identifier: data.identifier,
            image: image,
            filterColors: filterColors,
            defaultColor: defaultColor,
            imageBlendMode: .named(data.imageBlendMode ?? ""),
            textConfiguration: .init(from: data.textConfiguration)
        )
    }
}
