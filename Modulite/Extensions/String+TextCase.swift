//
//  String+TextCase.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/08/24.
//

import Foundation

extension String {
    
    enum TextCase {
        case upper
        case lower
        case camel
        case capitalized
    }
    
    func camelCased() -> String {
        let words = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let firstWord = words.first?.lowercased() ?? ""
        let remainingWords = words.dropFirst().map { $0.capitalized }
        return firstWord + remainingWords.joined()
    }
}
