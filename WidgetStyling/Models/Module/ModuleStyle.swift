//
//  ModuleStyle.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public protocol ModuleStyle {
    var filterColors: [UIColor] { get }
    var defaultColor: UIColor { get }
    var imageBlendMode: CGBlendMode? { get }
    var textConfiguration: ModuleTextConfiguration { get }
}

public class ModuleTextConfiguration {
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

extension String {
    
    enum TextCase {
        case upper
        case lower
        case camel
        case capitalized
    }
    
    func camelCased() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = trimmedString.components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        guard !words.isEmpty else { return "" }
        
        guard !isStringCamelCased(self) else { return self }

        let firstWord = words.first!.lowercased()
        let remainingWords = words.dropFirst().map { $0.capitalized }
        
        return firstWord + remainingWords.joined()
    }
    
    private func isStringCamelCased(_ string: String) -> Bool {
        guard !isEmpty else { return true }
        
        var result = ""
        var isNextCapital = false
        
        for (index, char) in self.enumerated() {
            if index == 0 {
                result.append(char.lowercased())
                continue
            }
            
            if char.isUppercase {
                result.append(char)
                isNextCapital = false
                continue
            }
            
            if char.isWhitespace || !char.isLetter {
                isNextCapital = true
                continue
            }
            
            result.append(isNextCapital ? char.uppercased() : char.lowercased())
            isNextCapital = false
        }
        
        return result == string
    }
}
