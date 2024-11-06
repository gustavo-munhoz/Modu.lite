//
//  ModuleTextConfiguration.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public class ModuleTextConfiguration {
    // MARK: - Properties
    var font: UIFont?
    var textColor: UIColor?
    var textAlignment: NSTextAlignment?
    var shadowColor: UIColor?
    var shadowOffset: CGSize?
    var shadowBlurRadius: CGFloat?
    var letterSpacing: CGFloat?
    var textCase: String.TextCase?
    var shouldRemoveSpaces: Bool = false
    var preffix: String?
    var suffix: String?

    // MARK: - Initializers
    init() { }
    
    convenience init(from data: ModuleTextConfigurationData) {
        self.init()
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
    
    func preffix(_ preffix: String) -> Self {
        self.preffix = preffix
        return self
    }
    
    func suffix(_ suffix: String) -> Self {
        self.suffix = suffix
        return self
    }
}
