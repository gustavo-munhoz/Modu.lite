//
//  String+TextCase.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import Foundation

extension String {
    
    enum TextCase {
        case upper
        case lower
        case camel
        case capitalized
        
        init?(from string: String) {
            switch string.lowercased() {
            case "upper":
                self = .upper
            case "lower":
                self = .lower
            case "camel":
                self = .camel
            case "capitalized":
                self = .capitalized
            default:
                return nil
            }
        }
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
