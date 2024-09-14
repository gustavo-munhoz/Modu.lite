//
//  UIFontExtensionTests.swift
//  ModuliteTests
//
//  Created by Gustavo Munhoz Correa on 14/09/24.
//

import XCTest
@testable import Modulite

class UIFontExtensionsTests: XCTestCase {

    func testFontWithTextStyleAndWeight() {
        let textStyle: UIFont.TextStyle = .body
        let weight: UIFont.Weight = .bold
        
        let font = UIFont(textStyle: textStyle, weight: weight)
                
        XCTAssertNotNil(font)
        XCTAssertEqual(font.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle, textStyle)
        
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weightValue = traits?[.weight] as? NSNumber
        XCTAssertEqual(weightValue?.floatValue, Float(weight.rawValue))
    }
    
    func testFontWithTextStyleAndSymbolicTraits() {
        let textStyle: UIFont.TextStyle = .headline
        let traits: UIFontDescriptor.SymbolicTraits = .traitBold

        let font = UIFont(textStyle: textStyle, symbolicTraits: traits)
        
        XCTAssertNotNil(font)
        XCTAssertTrue(font!.fontDescriptor.symbolicTraits.contains(traits))
    }

    func testFontWithTextStyleWeightAndItalic() {
        let textStyle: UIFont.TextStyle = .subheadline
        let weight: UIFont.Weight = .medium
        let italic = true
        
        let font = UIFont(textStyle: textStyle, weight: weight, italic: italic)
                
        XCTAssertNotNil(font)
                
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weightValue = traits?[.weight] as? NSNumber
        
        XCTAssertEqual(weightValue?.floatValue, Float(weight.rawValue))
        XCTAssertTrue(font.fontDescriptor.symbolicTraits.contains(.traitItalic))
    }
    
    func testFontWithTextStyleWeightAndNonItalic() {
        let textStyle: UIFont.TextStyle = .footnote
        let weight: UIFont.Weight = .light
        let italic = false
        
        let font = UIFont(textStyle: textStyle, weight: weight, italic: italic)
                
        XCTAssertNotNil(font)
                
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weightValue = traits?[.weight] as? NSNumber
        
        XCTAssertEqual(weightValue?.floatValue, Float(weight.rawValue))
        XCTAssertNil(traits?[.symbolic])
    }
}
