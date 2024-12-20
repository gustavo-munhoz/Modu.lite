//
//  ModuleTextConfiguration.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class ModuleTextConfiguration {
    // MARK: - Properties
    public var font: UIFont?
    public var fontSize: CGFloat?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var shadowColor: UIColor?
    public var shadowOffset: CGSize?
    public var shadowBlurRadius: CGFloat?
    public var shadowOpacity: CGFloat?
    public var letterSpacing: CGFloat?
    public var textCase: String.TextCase?
    public var shouldRemoveSpaces: Bool = false
    public var prefix: String?
    public var suffix: String?
    public var bottomRelativePosition: CGFloat?

    // MARK: - Initializers
    static func create(from data: ModuleTextConfigurationData) -> ModuleTextConfiguration {
        let configuration = ModuleTextConfiguration()
        
        configureFont(for: configuration, from: data)
        configureColors(for: configuration, from: data)
        configureTextProperties(for: configuration, from: data)
        
        configuration.shouldRemoveSpaces = data.shouldRemoveSpaces ?? false
        configuration.prefix = data.prefix
        configuration.suffix = data.suffix

        return configuration
    }

    // MARK: - Helper Methods

    private static func configureFont(
        for configuration: ModuleTextConfiguration,
        from data: ModuleTextConfigurationData
    ) {
        guard let fontSize = data.fontSize else { return }
        let weight = UIFont.Weight.from(string: data.fontWeight)
        
        if let fontName = data.fontName, !fontName.isEmpty, fontName.lowercased() != "system" {
            if let customFont = UIFont(name: fontName, size: fontSize) {
                configuration.font = customFont
            }
        } else {
            configuration.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
    }

    private static func configureColors(
        for configuration: ModuleTextConfiguration,
        from data: ModuleTextConfigurationData
    ) {
        if let textColorName = data.textColorName {
            configuration.textColor = UIColor.fromWidgetStyling(named: textColorName)
        }
        
        if let shadowColorName = data.shadowColorName {
            configuration.shadowColor = UIColor.fromWidgetStyling(
                named: shadowColorName
            )
        }
        
        configuration.shadowOffset = CGSize(
            width: data.shadowOffsetWidth ?? 0,
            height: data.shadowOffsetHeight ?? 0
        )
        
        if let shadowOpacity = data.shadowOpacity {
            configuration.shadowOpacity = shadowOpacity
        }
        
        if let shadowBlurRadius = data.shadowBlurRadius {
            configuration.shadowBlurRadius = shadowBlurRadius
        }
    }

    private static func configureTextProperties(
        for configuration: ModuleTextConfiguration,
        from data: ModuleTextConfigurationData
    ) {
        if let alignment = data.textAlignment {
            configuration.textAlignment = NSTextAlignment(from: alignment)
        }
        
        if let width = data.shadowOffsetWidth, let height = data.shadowOffsetHeight {
            configuration.shadowOffset = CGSize(width: width, height: height)
        }
        
        if let blurRadius = data.shadowBlurRadius {
            configuration.shadowBlurRadius = blurRadius
        }
        
        if let spacing = data.letterSpacing {
            configuration.letterSpacing = spacing
        }
        
        if let caseString = data.textCase {
            configuration.textCase = String.TextCase(from: caseString)
        }
        
        if let bottomRelativePosition = data.bottomRelativePosition {
            configuration.bottomRelativePosition = bottomRelativePosition
        }
    }
    
    // MARK: - Methods
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func shadow(
        color: UIColor,
        offset: CGSize = .zero,
        blurRadius: CGFloat = .zero
    ) -> Self {
        self.shadowColor = color
        self.shadowOffset = offset
        self.shadowBlurRadius = blurRadius
        return self
    }
    
    func textCase(_ textCase: String.TextCase) -> Self {
        self.textCase = textCase
        return self
    }
    
    func removingSpaces() -> Self {
        self.shouldRemoveSpaces = true
        return self
    }
    
    func prefix(_ prefix: String) -> Self {
        self.prefix = prefix
        return self
    }
    
    func suffix(_ suffix: String) -> Self {
        self.suffix = suffix
        return self
    }
}
