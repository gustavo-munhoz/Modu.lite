//
//  UIFontExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 14/09/24.
//

import Testing
import UIKit
@testable import Modulite

struct UIFontExtensionsTests {

    @Test("Font has text style and weight")
    func fontWithTextStyleAndWeight() {
        let textStyle: UIFont.TextStyle = .body
        let weight: UIFont.Weight = .bold
        
        let font = UIFont(textStyle: textStyle, weight: weight)
                        
        #expect(font != nil)
        #expect(font.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle == textStyle)
        
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weightValue = traits?[.weight] as? NSNumber
        
        #expect(weightValue?.floatValue == Float(weight.rawValue))
    }
    
    @Test("Font has text style and symbolic traits")
    func fontWithTextStyleAndSymbolicTraits() {
        let textStyle: UIFont.TextStyle = .headline
        let traits: UIFontDescriptor.SymbolicTraits = .traitBold

        let font = UIFont(textStyle: textStyle, symbolicTraits: traits)
        
        #expect(font != nil)
        #expect(font!.fontDescriptor.symbolicTraits.contains(traits))
    }

    @Test("Font has text style, weight and italic traits")
    func fontWithTextStyleWeightAndItalic() {
        let textStyle: UIFont.TextStyle = .subheadline
        let weight: UIFont.Weight = .medium
        let italic = true
        
        let font = UIFont(textStyle: textStyle, weight: weight, italic: italic)
                
        #expect(font != nil)
                
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weightValue = traits?[.weight] as? NSNumber
        
        #expect(weightValue?.floatValue == Float(weight.rawValue))
        #expect(font.fontDescriptor.symbolicTraits.contains(.traitItalic))
    }
    
    @Test("Font has text style, weight and non-italic traits")
    func testFontWithTextStyleWeightAndNonItalic() {
        let textStyle: UIFont.TextStyle = .footnote
        let weight: UIFont.Weight = .light
        let italic = false
        
        let font = UIFont(textStyle: textStyle, weight: weight, italic: italic)
                
        #expect(font != nil)
                
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weightValue = traits?[.weight] as? NSNumber
        
        #expect(weightValue?.floatValue == Float(weight.rawValue))
        #expect(traits?[.symbolic] == nil)
    }
}
